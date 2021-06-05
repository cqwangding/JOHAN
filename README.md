# JOHAN: A Joint Online Hurricane Trajectory and Intensity Forecasting Framework

## Project Details

The JOHAN Algorithm was implemented using Matlab. It applied on the hurricane trajectory and intensity dataset collected from year 2012 to 2020. Execute run.m in Matlab environment to generate all the experiment results.

## Dataset

The ground truth hurricane trajectory data along with the official forecasts are obtained from the National Hurricane Center (NHC) website: [https://www.nhc.noaa.gov](https://www.nhc.noaa.gov)

The ensemble member forecasts are obtained from the Hurricane Forecast Model Output website at University of Wisconsin-Milwaukee: [http://derecho.math.uwm.edu/models](http://derecho.math.uwm.edu/models)

We collected 6-hourly hurricane trajectory and intensity data from the year 2012 to 2020, which contains 336 tropical cyclones. Each tropical cyclone has an average length of 21.9 time steps (data points), which gives a total of 7364 data points. There are 27 trajectory forecast models and 21 intensity forecast models used in our experiments, which are a subset of the models used by NHC in the preparation of their official forecasts. The data from 2012 to 2017 (208 tropical cyclones) are used for  training and validation, while those from 2018 to 2020 (128 tropical cyclones) are used for testing.

In data folder, the variables saved in each file are described as follows:

| Filename                   | Variable description                                         |
| -------------------------- | ------------------------------------------------------------ |
| forecasts_tra.mat          | X: size 27x2x9x7364, 27 models, latitude and longitude, current location + 1-8 lead times forecasts, 7364 time steps |
|                            | Y: size 2x9x7364, best track location for corresponding X    |
|                            | NHC: size 2x9x7364, official forecasts from NHC              |
|                            | time: size 336x2,  start time step and end time step for 336 hurricanes |
|                            | splits: size 3x2, start hurricane number and end hurricane number for model training, validation and testing |
| forecasts_int.mat          | X: size 21x1x9x7364, 21 models, intensity in kt, current location + 1-8 lead times forecasts, 7364 time steps |
|                            | Y: size 1x9x7364, best track location for corresponding X    |
|                            | NHC: size 1x9x7364, official forecasts from NHC              |
|                            | time: size 336x2,  start time step and end time step for 336 hurricanes |
|                            | splits: size 3x2, start hurricane number and end hurricane number for model training, validation and testing |
| forecasts_tra_int_cell.mat | X, Y, NHC: 1x2 cell, consists of the same variables in forecasts_tra.mat and forecasts_int.mat |
|                            | time, splits: the same as variables in forecasts_tra.mat     |
| hurricane.mat              | hurricane: size 1x336, contains hurricane id, name, location (Atlantic, Eastern and Central Pacific), start time and end time |
| model.mat                  | model: 1x167, contains model id, type and interval (6-hour, 12-hour) |
| predict_flag.mat           | predict_flag: 9x7364, marked whether any model output is collected at each time step and lead time |
| predict.mat                | predict: saved baseline predictions and JOHAN predictions    |

## Parameters for JOHAN Algorithm

The parameters for JOHAN algorithm are described as follows:

| Parameter name   | Description                                                  |
| ---------------- | ------------------------------------------------------------ |
| opts.error_type  | 1: distance loss, 2: L1 loss, 3: L2 loss                     |
| opts.unit_change | The final output will be divided by this variable for unit change purpose |
| opts.use_predict | In backtracking and restart, the forecasts generated at current time step can be used as ground truth in the past time step. In our experiments, this technique can further improve the hurricane trajectory predictions but not intensity predictions. |
| opts.geo         | Whether the input features are geographic data (latitude, longitude) |
| opts.rho         | Hyperparameter ρ, controls the trade off between using the weights from current and past hurricane |
| opts.gamma       | Hyperparameter γ, determines the relative importance of making accurate forecasts at different lead times. |
| opts.omega       | Hyperparameter ω, ensures smoothness in the model parameters for different lead times |
| opts.mu          | Hyperparameter μ, designed to ensure the hurricane-specific factor **u** do not change rapidly from their previous values at time t−1 |
| opts.nu          | Hyperparameter ν, designed to ensure the lead time adjustment **v** do not change rapidly from their previous values at time t−1 |
| opts.eta         | Hyperparameter η, imposes a  sparsity constraint on the lead time adjustment factor |

## Results

Trajectory and intensity forecast errors for hurricanes within 200 n mi to coastline with intensity at least 64 kt for different methods at varying lead times from 12 to 48 hours.

| Algorithm name     | Trajectory forecast error (in n mi) | Intensity forecast error (in kt) |
| ------------------ | -------------------------------- | ------------------------------- |
| Lead Times (hours) | 12		24		36		48 | 12		24		36		48 |
| Ensemble Mean      | 15.80	28.47	41.21	52.09 | 6.742	8.692	9.899	11.036 |
| Persistence        | 34.28	87.62	159.38	228.91 | 13.121	22.547	29.194	32.762 |
| PA                 | 15.81	28.48	41.22	51.98 | 8.765	16.042	24.275	24.656 |
| ORION              | 16.02	28.61	41.29	52.15 | 8.483	13.171	16.806	17.555 |
| OMuLeT             | 15.33	28.28	39.65	49.67 | 9.064	14.435	17.562	18.317 |
| NHC                | 16.69	29.47	42.83	54.07 | 7.962	13.585	16.097	17.587 |
| JOHAN              | 15.28	28.15	39.28	49.06 | 8.963	13.367	16.270	16.554 |

## Cite JOHAN

If you find JOHAN or hurricane dataset useful for your research, please consider citing our paper:

```
@inproceedings{wang2021johan,
  title={{JOHAN: A Joint Online Hurricane Trajectory and Intensity Forecasting Framework}},
  author={Wang, Ding and Tan, Pang-Ning},
  booktitle={Proceedings of the 27th ACM SIGKDD Conference on Knowledge Discovery and Data Mining},
  year={2021}
}
```

