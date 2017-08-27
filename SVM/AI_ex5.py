#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2016/11/21 AM9:33
# @Author  : Shiloh Leung
# @Site    : 
# @File    : AI_ex5.py
# @Software: PyCharm Community Edition
import SVMclassifier as svm
trainfn = '/Users/liangsiqi/Documents/Python/AI_ex5/traindata.txt'
testfn = '/Users/liangsiqi/Documents/Python/AI_ex5/testdata.txt'
dataArr, labelArr = svm.loadDataSet(trainfn)
dataArr_test, labelArr_test = svm.loadDataSet(testfn)
b, alpha = svm.smoP(dataArr, labelArr, 6, 0.001, 50)
ws = svm.calcWs(alpha, dataArr, labelArr)
trainrate = svm.predict(dataArr, labelArr, ws, b)
testrate = svm.predict(dataArr_test, labelArr_test, ws, b)
print("训练数据集上的预测准确率为: ", trainrate)
print("测试数据集上的预测准确率为: ", testrate)
