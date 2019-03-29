import importlib
import pytest
import json
import sys

import numpy as np
import torch

from delphi.GrFN.networks import GroundedFunctionNetwork

data_dir = "tests/data/GrFN/"
sys.path.insert(0, "tests/data/program_analysis")
CROP_YIELD_GrFN = GroundedFunctionNetwork.from_fortran_file("tests/data/program_analysis/crop_yield.f")
PETASCE_GrFN = GroundedFunctionNetwork.from_fortran_file("tests/data/program_analysis/PETASCE_simple.for")
PETPT_GrFN = GroundedFunctionNetwork.from_fortran_file("tests/data/program_analysis/PETPT.for")


def test_petpt_creation_and_execution():
    assert isinstance(PETPT_GrFN, GroundedFunctionNetwork)
    assert len(PETPT_GrFN.inputs) == 5
    assert len(PETPT_GrFN.outputs) == 1

    values = {name: 1 for name in PETPT_GrFN.inputs}
    res = PETPT_GrFN.run(values)
    assert res == 0.02998371219618677


def test_petasce_creation():
    A = PETASCE_GrFN.to_agraph()
    CAG = PETASCE_GrFN.to_CAG_agraph()
    CG = PETASCE_GrFN.to_call_agraph()

    values = {
        "petasce::doy_-1": 20,
        "petasce::meevp_-1": "A",
        "petasce::msalb_-1": 0.5,
        "petasce::srad_-1": 15,
        "petasce::tmax_-1": 10,
        "petasce::tmin_-1": -10,
        "petasce::xhlai_-1": 10,
        "petasce::tdew_-1": 20,
        "petasce::windht_-1": 5,
        "petasce::windrun_-1": 450,
        "petasce::xlat_-1": 45,
        "petasce::xelev_-1": 3000,
        "petasce::canht_-1": 2,
    }

    res = PETASCE_GrFN.run(values)
    assert res == 0.00012496980836348878


def test_crop_yield_creation():
    A = CROP_YIELD_GrFN.to_agraph()
    assert isinstance(CROP_YIELD_GrFN, GroundedFunctionNetwork)


@pytest.mark.skip
def test_petasce_torch_execution():
    lambdas = importlib.__import__("PETASCE_simple_torch_lambdas")
    pgm = json.load(open(data_dir + "PETASCE_simple_torch.json", "r"))
    G = GroundedFunctionNetwork.from_dict(pgm, lambdas)

    N = 100
    samples = {
        "petasce::doy_0": np.random.randint(1, 100, N),
        "petasce::meevp_0": np.where(np.random.rand(N) >= 0.5, 'A', 'W'),
        "petasce::msalb_0": np.random.uniform(0, 1, N),
        "petasce::srad_0": np.random.uniform(1, 30, N),
        "petasce::tmax_0": np.random.uniform(-30, 60, N),
        "petasce::tmin_0": np.random.uniform(-30, 60, N),
        "petasce::xhlai_0": np.random.uniform(0, 20, N),
        "petasce::tdew_0": np.random.uniform(-30, 60, N),
        "petasce::windht_0": np.random.uniform(0, 10, N),
        "petasce::windrun_0": np.random.uniform(0, 900, N),
        "petasce::xlat_0": np.random.uniform(0, 90, N),
        "petasce::xelev_0": np.random.uniform(0, 6000, N),
        "petasce::canht_0": np.random.uniform(0.001, 3, N),
    }

    values = {
        k: torch.tensor(v, dtype=torch.double) if v.dtype != "<U1" else v
        for k, v in samples.items()
    }

    res = G.run(values, torch_size=N)
    assert res.size()[0] == N