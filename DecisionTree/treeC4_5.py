#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2016/11/14 PM11:30
# @Author  : Shiloh Leung
# @Site    : 
# @File    : treeC4_5.py
# @Software: PyCharm Community Edition
from math import log
import operator

def createDataSet(filename):
    dataSet = []
    fr = open(filename)
    labels = ['feature 1', 'feature 2', 'feature 3', 'feature 4']
    for line in fr.readlines():
        lineArr = line.strip().split()
        dataSet.append([float(lineArr[0]), float(lineArr[1]), float(lineArr[2]), \
                                           float(lineArr[3]), int(lineArr[4])])
    return dataSet, labels


def calcShannonEnt(dataSet):
    numEntries = len(dataSet)
    labelCounts = {}
    for featVet in dataSet:
        currentLabel = featVet[-1]
        if currentLabel not in labelCounts.keys():
            labelCounts[currentLabel] = 0
        labelCounts[currentLabel] += 1
    shannonEnt = 0.0
    for key in labelCounts:
        prob = float(labelCounts[key]) / numEntries
        shannonEnt -= prob*log(prob, 2)
    return shannonEnt


def splitDataSet(dataSet, axis, value, flag):
    # if flag = 1, return dataset whose feature of axis greater than value
    # if flag = 0, return dataset whose feature of axis smaller than value
    retDataSet = []
    if flag == 1:
        for featVec in dataSet:
            if featVec[axis]>value:
                reducedFeatVec = featVec[:axis]
                reducedFeatVec.extend(featVec[axis+1:])
                retDataSet.append(reducedFeatVec)
    if flag == 0:
        for featVec in dataSet:
            if featVec[axis]<value:
                reducedFeatVec = featVec[:axis]
                reducedFeatVec.extend(featVec[axis+1:])
                retDataSet.append(reducedFeatVec)
    return retDataSet



def chooseBestFeatureToSplit(dataSet):
    # get the best feature to split dataset
    numFeatures = len(dataSet[0]) - 1
    baseEntropy = calcShannonEnt(dataSet)
    bestInfoGainRatio = 0.0;  bestFeature = -1
    for i in range(numFeatures):
        featList = [example[i] for example in dataSet]
        sortfeatList = sorted(list(set(featList)))
        uniqueVals = [(sortfeatList[j]+sortfeatList[j+1])/2 for j in range(len(sortfeatList)-1)]
        bestVal = 0.0;  bestValInfoGainRatio = 0.0
        # find the best value to split dataset
        for value in uniqueVals:
            ValInfoGainRatio = 0.0
            uppersubDataSet = splitDataSet(dataSet, i, value, 1)     # get upper dataset
            lowersubDataSet = splitDataSet(dataSet, i, value, 0)     # get lower dataset
            upperProb = len(uppersubDataSet) / float(len(dataSet))
            lowerProb = len(lowersubDataSet) / float(len(dataSet))
            ValInfoGain = baseEntropy - upperProb*calcShannonEnt(uppersubDataSet) \
                                      - lowerProb*calcShannonEnt(lowersubDataSet)
            if lowerProb*upperProb != 0:
                IV = - upperProb*log(upperProb, 2) - lowerProb*log(lowerProb, 2)
            elif lowerProb == 0:
                IV = - upperProb * log(upperProb, 2)
            else:
                IV = - lowerProb * log(lowerProb, 2)

            ValInfoGainRatio = ValInfoGain / IV
            if ValInfoGainRatio > bestValInfoGainRatio:
                bestVal = value
                bestValInfoGainRatio = ValInfoGainRatio
        if bestValInfoGainRatio > bestInfoGainRatio:
            bestFeature = i
            bestInfoGainRatio = bestValInfoGainRatio
            bestPoint = bestVal
    return bestFeature, bestPoint



def majorityCnt(classList):
    # If dataset has already no feature left, and has more than one class of examples,
    # use voting to decide the class of leaf note
    classCount = {}
    for vote in classList:
        if vote not in classCount.keys():
            classCount[vote] = 0
        classCount[vote] += 1
    sortedClassCount = sorted(classCount.items(), key=operator.itemgetter(1), reverse=True)
    return sortedClassCount[0][0]


def createTree(dataSet, labels, maxDepth):
    classList = [example[-1] for example in dataSet]
    if maxDepth==0:    # if the depth has already reached maxDepth, use voting to decide the class of leaf note
        return majorityCnt(classList)
    if len(classList) == 0:
        return None
    if classList.count(classList[0]) == len(classList):
        return classList[0]
    if len(dataSet[0]) == 1:
        return majorityCnt(classList)

    bestFeat, bestVal = chooseBestFeatureToSplit(dataSet)
    bestValStr = "%.2f" % bestVal
    bestFeatLabel = labels[bestFeat]
    myTree = {bestFeatLabel + '--value:' + bestValStr:{}}
    del(labels[bestFeat])
    featValues = [example[bestFeat] for example in dataSet]
    subLabels = labels[:]
    myTree[bestFeatLabel + '--value:' + bestValStr][0] = createTree(splitDataSet(dataSet, bestFeat, bestVal, 0), \
                                                                    subLabels, maxDepth-1)
    myTree[bestFeatLabel + '--value:' + bestValStr][1] = createTree(splitDataSet(dataSet, bestFeat, bestVal, 1), \
                                                                    subLabels, maxDepth-1)
    return myTree


def predict(example, myTree):
    firstStr = list(myTree.keys())[0]
    secondDict = myTree[firstStr]
    firstFeatAxis = int(list(myTree.keys())[0][8]) - 1
    firstVal = float(list(myTree.keys())[0][-4:])
    if example[firstFeatAxis]>firstVal:
        if type(secondDict[1]).__name__ == 'dict':
            return predict(example, secondDict[1])
        else:
            return secondDict[1]
    else:
        if type(secondDict[0]).__name__ == 'dict':
            return predict(example, secondDict[0])
        else:
            return secondDict[0]



def precCal(DataSet, myTree):
    ExampleCnt = len(DataSet)
    RightCnt = 0
    for example in DataSet:
        if predict(example, myTree) == example[-1]:
            RightCnt += 1
    return float(RightCnt)/ExampleCnt
