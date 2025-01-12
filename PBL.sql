--Nomer 1
SELECT 
    country,                             
    operator,                            
    COUNT(*) AS subscription_count,     
    SUM(revenue) AS total_revenue,       
    SUM(CASE 
        WHEN profile_status = 'inactive' AND status = -1 THEN 1  
        ELSE 0 
    END) AS subscription_churn,  
    ROUND(
        (SUM(CASE 
            WHEN profile_status = 'inactive' AND status = -1 THEN 1 
            ELSE 0 
        END) * 1.0 / COUNT(*)) * 100,  
        2
    ) AS churn_rate_percentage          
FROM 
    cleaned_dataset_v6_new              
GROUP BY 
    country, operator;                

 --Nomer 2
 --ver 1
 SELECT 
    country,                             
    operator,                            
    FLOOR(subscription_tenure_days / 30) AS subscription_cycle,  
    COUNT(*) AS total_subscriptions,      
    SUM(CASE 
        WHEN profile_status = 'inactive' AND status = -1 THEN 1  
        ELSE 0 
    END) AS churn_count,                
    ROUND(
        (SUM(CASE 
            WHEN profile_status = 'inactive' AND status = -1 THEN 1  
            ELSE 0 
        END) * 1.0 / COUNT(*)) * 100,  
        2
    ) AS churn_rate
FROM 
    cleaned_dataset_v6_new
GROUP BY 
    country, operator, subscription_cycle;
    
 --ver 2
 SELECT 
    country,                            
    operator,                            
    CASE
        WHEN subscription_tenure_days BETWEEN 0 AND 30 THEN '0-30 days'
        WHEN subscription_tenure_days BETWEEN 31 AND 60 THEN '31-60 days'
        WHEN subscription_tenure_days BETWEEN 61 AND 90 THEN '61-90 days'
        WHEN subscription_tenure_days BETWEEN 91 AND 120 THEN '91-120 days'
        ELSE '120+ days'                   
    END AS subscription_cycle,      
    COUNT(*) AS total_subscriptions,      
    SUM(CASE 
        WHEN profile_status = 'inactive' AND status = -1 THEN 1  
        ELSE 0 
    END) AS churn_count,                 
    ROUND(
        (SUM(CASE 
            WHEN profile_status = 'inactive' AND status = -1 THEN 1  
            ELSE 0 
        END) * 1.0 / COUNT(*)) * 100,  
        2
    ) AS churn_rate                     
FROM 
    cleaned_dataset_v6_new
GROUP BY 
    country, operator, subscription_cycle;

--Nomer 3
 SELECT 
    cycle, 
    country,  
    operator,  
    COUNT(CASE WHEN success_billing != 0 THEN 1 END) AS successful_billings,  
    COUNT(*) AS total_attempts,  
    ROUND(
        (COUNT(CASE WHEN success_billing != 0 THEN 1 END) * 1.0 / COUNT(*)) * 100,  
        2
    ) AS success_rate  
FROM 
    cleaned_dataset_v6_new
GROUP BY 
    cycle, country, operator
ORDER BY 
    success_rate DESC;