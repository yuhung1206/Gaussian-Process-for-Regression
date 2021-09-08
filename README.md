# Gaussian-Process-for-Regression
 - Implementation of **Gaussian Process (GP)** for regreesion with the **exponential-quadratic kernel** function.
 - We have 100 pairs of samples (x,t) in 'gp.mat' for training & testing.  
   Consider the 60% as traing data, 40% as testing.  
 - Given that the input x is limited in [0,2], predict the target t using GP.

## Implmentation process
 1. Calculate the **kernel matrix** from the first 60 samples using the following equation:  
    ![image](https://user-images.githubusercontent.com/78803926/132491912-344d8e7d-7fc9-49d6-b14a-731e540cd965.png)  
 2. Calculate the Covariance matrix    
    ![image](https://user-images.githubusercontent.com/78803926/132492356-2b12c35d-5c6a-4808-95cf-a9b980fbf37b.png)  
    ![image](https://user-images.githubusercontent.com/78803926/132492458-d54c0f90-db05-41de-a7d3-d36b9d4fc10a.png) has values when n = m, so ![image](https://user-images.githubusercontent.com/78803926/132492715-4ca4db62-a351-463a-9e7a-799fab9d77cc.png)
is equal to ![image](https://user-images.githubusercontent.com/78803926/132492830-053ad4c1-6105-4504-a834-4a9a2848eea5.png)  
 3. Calculate the kernel vecotr suing testing & training input x using the following equation:  
     ![image](https://user-images.githubusercontent.com/78803926/132494133-4453b960-a119-4ddd-bbbc-0418bd81d348.png)  
     
 4. Calaulate the **variance c** of test set  
    ![image](https://user-images.githubusercontent.com/78803926/132494671-c83c0bea-1f3e-408a-a422-a9dd81df5ca3.png)  
    
 5. Obtain the **prediction** of tset set  
    ![image](https://user-images.githubusercontent.com/78803926/132494842-4104a9a1-ca36-4bde-acbb-b4f9dc90754c.png)  
    ![image](https://user-images.githubusercontent.com/78803926/132494890-ae8c09dd-28a0-41dc-9d68-cb6c58b794ab.png) represent the t in train set  
    - **Mean & Variance of predict distribution**  
      ![image](https://user-images.githubusercontent.com/78803926/132495161-6c80ccb0-b582-4b45-bf9b-83d3706c2b23.png)

## Investigate the Predict distribution
 - The procedure is similar to the above implementation:  
   Replace the input for test set with all the value in x-domain like [0, 0.01, 0.02, ... 2]  
 - Visualization:  
   ![image](https://user-images.githubusercontent.com/78803926/132496038-7d28454d-23c1-46b7-bd9e-20d7ad93dd5b.png)  
   
 ## Fine-tuning with different combinations of hyperparameters
  - Evaluation parameter is **root-mean-square (RMS)**  
    ![image](https://user-images.githubusercontent.com/78803926/132496898-99a87bec-3be9-40f0-a557-cc2e65f7277c.png)

  - Comparison Table:  
    ![image](https://user-images.githubusercontent.com/78803926/132496965-ffa45e58-4397-454e-8c40-92a953f1fbf5.png)

    It was found that the results of prediction are more accurate for Train & Test set when using the parameters {1,32,5,5}.  
      
      
   - Further Analysis:  
     To validate the individual influence of theta_0, theta_1, theta_2 and theta_3, we try the combination like **[1,0,0,0], [0,1,0,0], [0,0,1,0] and [0,0,0,1]** for GP Regression.  
     ![image](https://user-images.githubusercontent.com/78803926/132498421-d02cb5b8-0a15-4f99-ae99-514742d4e0e9.png)  
     It was found that the prediction will be degraded to **linear regression** if the other three values are all zero.  
     

       
    
  ## Best Combination for given dataset - ARD
   - **automatic relevance determination (ARD)**  
   ![image](https://user-images.githubusercontent.com/78803926/132517015-74a2f1ba-bf95-44d4-875c-c24f1b81ecbf.png)
   

      


