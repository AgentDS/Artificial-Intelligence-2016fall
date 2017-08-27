#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2016/11/15 AM10:10
# @Author  : Shiloh Leung
# @Site    : 
# @File    : AI_ex4.py
# @Software: PyCharm Community Edition
import treeC4_5 as tree
import treePlotter
trainData, labels = tree.createDataSet('/Users/liangsiqi/Documents/Python/AI_ex4/traindata.txt')
maxDepth = 1
myTree = tree.createTree(trainData, labels, maxDepth)
testData, labels = tree.createDataSet('/Users/liangsiqi/Documents/Python/AI_ex4/testdata.txt')
print("限定深度为", maxDepth, "时")
print("决策树结构:\n", myTree)     # print out the tree
#treePlotter.createPlot(myTree)    # plot the tree
precTrain = tree.precCal(trainData, myTree)    # calculate precise on training set
precTest = tree.precCal(testData, myTree)    # calculate precise on test set
print('训练数据集预测精度 : ', precTrain)
print('测试数据集预测精度 : ', precTest)

