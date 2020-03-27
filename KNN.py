import pandas as pd
import numpy as np

def KNN(X_train,X_test,Y_train):
 
    train_x= pd.DataFrame(X_train)
    test_x=pd.DataFrame(X_test)
    train_x=(train_x-train_x.mean())/train_x.std()
    test_x=(test_x-test_x.mean())/test_x.std()
    def distance(x,train_x,train_y):
        dist = (train_x.to_numpy() - x)**2
        dist = np.sum(dist, axis=1)
        dist=np.sqrt(dist)
        distances=pd.DataFrame()
        distances["class"]=train_y
        distances["dist"]=dist
        distances=distances.sort_values(by='dist', ascending=True)
        return distances
    def assignment(distances,k):
        data=distances[:k].to_numpy()
        word_counter = {}
        for word in data:
            value ={'count':0,'distance':0}
            if word[0] in word_counter:
                word_counter[word[0]]['count'] =  word_counter[word[0]]['count'] + 1
                word_counter[word[0]]['distance'] = word_counter[word[0]]['distance'] + word[1]
            else:
                value['count']=1
                value['distance'] =word[1]
                word_counter[word[0]] = value
        values = sorted(word_counter.items(), key=lambda x: (x[1]['count'],-x[1]['distance']), reverse=True)
        return(values[0][0])
    k=5
    results = np.array([])
    for index in test_x.index:
        distances=distance(test_x.loc[index].values,train_x,Y_train)
        results = np.append(results,assignment(distances,k))
    return results

