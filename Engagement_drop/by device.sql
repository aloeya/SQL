SELECT DATE_TRUNC('week', occurred_at) as week, 
       count(distinct user_id) AS active_users,
       COUNT( DISTINCT CASE WHEN e.device IN ('macbook pro','lenovo thinkpad','macbook air',
                            'dell inspiron notebook', 'asus chromebook',
                            'dell inspiron desktop','acer aspire notebook',
                            'hp pavilion desktop','acer aspire desktop',
                            'mac mini') THEN user_id ELSE NULL END) AS computer_engagement, 
       COUNT( DISTINCT CASE WHEN e.device IN ('iphone 5','samsung galaxy s4','nexus 5',
                              'iphone 5s','iphone 4s','nokia lumia 635',
                              'htc one','samsung galaxy note',
                              'amazon fire phone')
                              THEN  user_id ELSE NULL END) AS phone_engagment, 
                              
       COUNT(DISTINCT CASE WHEN e.device IN ('ipad air','nexus 7','ipad mini','nexus 10',
                               'kindle fire','windows surface','samsumg galaxy tablet')
                               THEN user_id ELSE NULL END) AS tablet_engagement 

FROM tutorial.yammer_events e

where event_type='engagement'
AND event_name='login'
GROUP BY week