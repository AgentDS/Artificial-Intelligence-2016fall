#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2016/11/21 AM9:31
# @Author  : Shiloh Leung
# @Site    : 
# @File    : SVMclassifier.py
# @Software: PyCharm Community Edition
import random
import numpy as np


def loadDataSet(filename):
    # /Users/liangsiqi/Documents/Python/AI_ex5/traindata.txt
    dataMat = [];  labelMat = []
    fr = open(filename)
    for line in fr.readlines():
        lineArr = line.strip().split('\t')
        dataMat.append([float(lineArr[0]), float(lineArr[1]), float(lineArr[2]), \
                        float(lineArr[3]), float(lineArr[4]), float(lineArr[5]), \
                        float(lineArr[6]), float(lineArr[7]), float(lineArr[8])])
        if int(lineArr[9]) == 1:
            labelMat.append(-1.0)
        else:
            labelMat.append(1.0)
    return dataMat, labelMat


def selectJrand(i, m):
    # m : number of a_j
    # i : i of a_i
    j = i
    while (j==i):
        j = int(random.uniform(0, m))
    return j


def clipAlpha(aj, H, L):
    if aj > H:
        aj = H
    if L > aj:
        aj = L
    return aj



class optStruct:
    def __init__(self, dataMatIn, classLabels, C, toler):
        self.X = dataMatIn
        self.labelMat = classLabels
        self.C = C
        self.tol = toler
        self.m = dataMatIn.shape[0]
        self.alphas = np.mat(np.zeros((self.m, 1)))
        self.b = 0
        self.eCache = np.mat(np.zeros((self.m, 2)))



def calcEk(oS, k):
    fXk = float(np.multiply(oS.alphas,oS.labelMat).T*(oS.X*oS.X[k,:].T) + oS.b)
    Ek = fXk - float(oS.labelMat[k])
    return Ek



def selectJ(i, oS, Ei):
    maxK = -1;  maxDeltaE = 0;  Ej = 0
    oS.eCache[i] = [1, Ei]
    validEcacheList = np.nonzero(oS.eCache[:,0].A)[0]
    if len(validEcacheList) > 1:
        for k in validEcacheList:
            if k == i: continue
            Ek = calcEk(oS, k)
            deltaE = abs(Ei - Ek)
            if deltaE > maxDeltaE:
                maxK = k;  maxDeltaE = deltaE;  Ej = Ek
        return maxK, Ej
    else:
        j = selectJrand(i, oS.m)
        Ej = calcEk(oS, j)
    return j, Ej


def updateEk(oS, k):
    Ek = calcEk(oS, k)
    oS.eCache[k] = [1, Ek]


def innerL(i, oS):
    Ei = calcEk(oS, i)
    if ((oS.labelMat[i]*Ei < -oS.tol) and (oS.alphas[i] < oS.C)) or \
        ((oS.labelMat[i]*Ei > oS.tol) and (oS.alphas[i] > 0)):
        j, Ej = selectJ(i, oS, Ei)
        alphaIold = oS.alphas[i].copy();  alphaJold = oS.alphas[j].copy()
        if oS.labelMat[i] != oS.labelMat[j]:
            L = max(0, oS.labelMat[j] - oS.labelMat[i])
            H = min(oS.C, oS.C + oS.labelMat[j] - oS.labelMat[i])
        else:
            L = max(oS.labelMat[j] + oS.labelMat[i] - oS.C, 0)
            H = min(oS.C, oS.labelMat[j] + oS.labelMat[i])
        if L == H:
            #print('L == H')
            return 0
        eta = 2.0 * oS.X[i,:]*oS.X[j,:].T - oS.X[i,:]*oS.X[i,:].T - oS.X[j,:]*oS.X[j,:].T
        if eta >= 0:
            #print("eta>=0")
            return  0
        oS.alphas[j] -= oS.labelMat[j]*(Ei - Ej)/eta
        oS.alphas[j] = clipAlpha(oS.alphas[j], H, L)
        updateEk(oS, j)
        if abs(oS.alphas[j]-alphaJold) < 0.00001:
            #print("j not moving enough")
            return 0
        oS.alphas[i] += oS.labelMat[j]*oS.labelMat[i]*(alphaJold - oS.alphas[j])
        updateEk(oS, i)
        b1 = oS.b - Ei - oS.labelMat[i] * (oS.alphas[i] - alphaIold) * oS.X[i,:]*oS.X[i,:].T - oS.labelMat[j] * (oS.alphas[j] - alphaJold) * oS.X[i,:]*oS.X[j,:].T
        b2 = oS.b - Ej - oS.labelMat[i] * (oS.alphas[i] - alphaIold) * oS.X[i,:]*oS.X[j,:].T - oS.labelMat[j] * (oS.alphas[j] - alphaJold) * oS.X[j,:]*oS.X[j,:].T
        if (0 < oS.alphas[i]) and (oS.C > oS.alphas[i]):
            oS.b = b1
        elif (0 < oS.alphas[j]) and (oS.C > oS.alphas[j]):
            oS.b = b2
        else:
            oS.b = (b1 + b2)/2.0
        return 1
    else:
        return 0


def smoP(dataMatIn, classLabels, C, toler, maxIter):
    oS = optStruct(np.mat(dataMatIn), np.mat(classLabels).transpose(), C, toler)
    iter = 0
    entireSet = True; alphaPairsChanged = 0
    while (iter < maxIter) and ((alphaPairsChanged > 0) or (entireSet)):
        alphaPairsChanged = 0
        if entireSet:
            for i in range(oS.m):
                alphaPairsChanged += innerL(i,oS)
                #print("fullSet, iter: %d i:%d, pairs changed %d" % (iter,i,alphaPairsChanged))
            iter += 1
        else:
            nonBoundIs = np.nonzero((oS.alphas.A > 0) * (oS.alphas.A < C))[0]
            for i in nonBoundIs:
                alphaPairsChanged += innerL(i,oS)
                #print("non-bound, iter: %d i:%d, pairs changed %d" % (iter,i,alphaPairsChanged))
            iter += 1
        if entireSet: entireSet = False
        elif (alphaPairsChanged == 0): entireSet = True
        #print("iteration number: %d" % iter)
    return oS.b,oS.alphas


def calcWs(alphas,dataArr,classLabels):
    X = np.mat(dataArr); labelMat = np.mat(classLabels).transpose()
    m,n = X.shape
    w = np.zeros((n,1))
    for i in range(m):
        w += np.multiply(alphas[i]*labelMat[i],X[i,:].T)
    return w

def predict(dataArr, labelArr, ws, b):
    right = 0
    weight = np.mat(ws)
    dataMat = np.mat(dataArr)
    m = dataMat.shape[0]
    for i in range(m):
        y = dataMat[i,:]*weight + b
        if (y*labelArr[i] > 0):
            right += 1
    return float(right)/m