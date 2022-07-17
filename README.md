 # Content-Based-Image-Classification

In this project, Content Based Image Classification (CBIC) System based on different types of histogram features is implemented. Different quantization levels are used for both grayscale intensity and color histograms. In addition, different levels of grids are applied during feature extraction. Finally, classification is done with K-Nearest Neighbour.



## HISTOGRAM BASED FEATURE EXTRACTION

In this section, features extracted for the image itself and classification is done for different number of neighbors and different quantization levels.

#### Grayscale Histogram

|      | q=1  | q=128 | q=256 |
| ---- | ---- | ----- | ----- |
| K=1  | 33   | 47.5  | 47.6  |
| K=5  | 24   | 39.7  | 39.7  |
| K=10 | 41   | 40    | 39    |

#### RGB Histogram

|      | q=1  | q=8  | q=16 |
| ---- | ---- | ---- | ---- |
| K=1  | 32.7 | 60   | 62.4 |
| K=5  | 24   | 40.6 | 49   |
| K=10 | 40   | 41   | 49   |

## GRID BASED FEATURE EXTRACTION

In this section, images are divided into a grid and histograms are extracted for each cell of the grid individually. Then, histograms are concatenate and feature vectors are created. 2x2 (level 2) and 4x4 (level 3) grids are used for grid based feature extraction, and classification is done for different number of K values and different quantization levels.

### Level 2

#### Grayscale Histogram

|      | q=1  | q=8  | q=16 |
| ---- | ---- | ---- | ---- |
| K=1  | 33   | 41   | 41   |
| K=5  | 28.4 | 42.4 | 40.6 |
| K=10 | 41   | 40   | 39.7 |

#### RGB Histogram

|      | q=1  | q=8  | q=16 |
| ---- | ---- | ---- | ---- |
| K=1  | 32.7 | 64   | 72.5 |
| K=5  | 28.4 | 69   | 59.4 |
| K=10 | 41   | 72   | 62.4 |



### Level 3

#### Grayscale Histogram

|      | q=1  | q=128 | q=256 |
| ---- | ---- | ----- | ----- |
| K=1  | 32   | 42.4  | 42    |
| K=5  | 31   | 42    | 40.6  |
| K=10 | 40   | 39.7  | 40.6  |

#### RGB Histogram

|      | q=1  | q=8  | q=16 |
| ---- | ---- | ---- | ---- |
| K=1  | 32.3 | 72   | 73   |
| K=5  | 31.4 | 55   | 72.1 |
| K=10 | 40.6 | 72.1 | 49   |



### 
