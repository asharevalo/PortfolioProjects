#!/usr/bin/env python
# coding: utf-8

# In[26]:


# Import Libraries

import pandas as pd
import numpy as np
import seaborn as sns

import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
import matplotlib
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8)

pd.options.mode.chained_assignment = None

#read in the data
df = pd.read_csv(r'C:\Users\ashle\Desktop\movies.csv')


# In[85]:


# viewing the data

df.head()


# In[28]:


# Checking for missing data

for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col, round(pct_missing*100)))
    


# In[18]:


#Data types for columns
print(df.dtypes)


# In[49]:


#change data types of columns
df['budget'] = df['budget'].astype('float64')
df['gross'] = df['gross'].astype('float64')


# In[86]:


df.head()


# In[32]:


#change release date to string and pull the year only
df['YearCorrect'] = df['released'].astype(str).str[:4]


# In[87]:


df.head()


# In[51]:


# Sort in descending order by Gross
df = df.sort_values(by=['gross'], inplace=False, ascending=False)


# In[42]:


pd.set_option('display.max_rows', None)


# In[43]:


# Remove any duplicates
df.drop_duplicates()


# In[88]:


df.head()


# In[53]:


# Scatter plot with budget vs gross

plt.scatter(x=df['budget'], y=df['gross'])

plt.title('Budget vs Gross Earnings')

plt.xlabel('Gross Earnings')

plt.ylabel('Budget for Film')

plt.show()


# In[52]:


df.head()


# In[58]:


# Plot budget vs gross using seaborn

sns.regplot(x='budget', y='gross', data=df, scatter_kws={'color':'red'}, line_kws={'color':'blue'})


# In[59]:


#looking at correlation

df.corr(method='pearson') 


# In[64]:


#High correlation between budget and gross

correlation_matrix = df.corr(method='pearson')

sns.heatmap(correlation_matrix, annot=True)

plt.title('Correlation Matrix for Numeric Features')

plt.xlabel('Movie Features')

plt.ylabel('Movie Features')

plt.show()


# In[89]:


#looking at company

df_numerized = df

for col_name in df_numerized.columns:
    if(df_numerized[col_name].dtype == 'object'):
        df_numerized[col_name] = df_numerized[col_name].astype('category')
        df_numerized[col_name] = df_numerized[col_name].cat.codes
        
df_numerized.head()


# In[90]:


df.head()


# In[79]:


correlation_matrix = df_numerized.corr(method='pearson')

sns.heatmap(correlation_matrix, annot=True)

plt.title('Correlation Matrix for Numeric Features')

plt.xlabel('Movie Features')

plt.ylabel('Movie Features')

plt.show()


# In[81]:


df_numerized.corr()


# In[82]:


correlation_mat = df_numerized.corr()

corr_pairs = correlation_mat.unstack()

corr_pairs


# In[83]:


sorted_pairs = corr_pairs.sort_values()

sorted_pairs


# In[84]:


high_corr = sorted_pairs[(sorted_pairs) > 0.5]

high_corr


# In[ ]:


# Votes and budget have the highest correlation to gross earnings.

#Company has low correlation.

