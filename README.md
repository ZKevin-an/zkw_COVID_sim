# zkw_COVID_sim

该程序设计用于模拟新冠病毒在人群中的传播。
* 场景：最基础的场景，无阻挡物，中国地区，2D正方形区域内
* 结果：可设置参数和控制程序运行的gui界面，同时出现数字指标与可视化传播模型，可根据不同防疫措施改变传染率，接触人数等计算出该措施下的数字指标与可视模型
* 使用语言：`matlab`
* 参考：参考论文与代码在后文提及
> 注：该工程中实现功能的代码为zkw_Covid_visual_sim，运行它即可完成题目要求，其他三份代码（SEIR_sim.m、Covid_China_sim、cellular_automata_sim）
均为zkw_Covid_visual_sim提供设计思路和必要验证。

## 项目基本说明：
工程包含四份代码，它们的作用为：
1. SEIR_sim.m：建立了最基本的SEIR模型，并通过曲线图画出了在改模型下病毒传播的数字指标，为最后的仿真模型做测试。
2. Covid_China_sim：参考武汉学报“多阶段动态时滞动力学模型的COVID⁃19传播分析”，构建了一个基于中国的新冠传播模型，并通过多阶段加时滞的设置将该模型呈现出与中国疫情情况基本吻合的仿真模型，疫情峰值与转折点都与目前情况相同，为最后防控手段采用提供依据。
3. cellular_automata_sim：建立了一个基本的元胞自动机扩散模型，用于模拟病毒的可视化传播，为最后的可视化模型做测试与启示。
4. zkw_Covid_visual_sim：根据题目要求作出的新冠传播仿真程序，首先提供了可视化的传播模型，并相应给出了数字指标，通过两者相应验证新冠传播的恐怖，然后根据几份参考论文（参考论文见下面）得到传播的各种参数（如传染率，接触人数，康复率等），放入到自己的传播模型中，传播模型分别是借用了上述的SEIR_sim.m和cellular_automata_sim作出了曲线图和扩散视图，并且程序可以根据戴口罩，消毒，社交隔离，强制隔离来改变各个参数，并看到改变参数后的传播模型，从而给出防疫的依据。

## 运行代码方式
`win10`、`matlab 2017b`及以上版本运行即可（更低版本未测试过）

## 代码使用说明
用matlab打开zkw_Covid_visual_sim后直接点运行即可，首先可以看到速度，确诊者感染率，潜伏者感染率，确诊者接触人数，潜伏者接触人数，潜伏者变为感染者概率，康复率7个参数的设置，一开始是将该参数设置成了目前COVID-2019在中国传播的根据统计学（根据“多阶段动态时滞动力学模型的COVID⁃19传播分析”的参考）计算出的参数值，可先不必动。然后有set、start、restart、puase、
go on五个按钮，这五个按钮的作用分别为：
* set：点击后上述七个参数设置到程序内
* start：开始仿真
* restart：关闭当前仿真，重新开始（需要再按下start按钮）
* pause：暂停程序
* go on：继续程序

程序主要操作：通过设置好参数后，点击set将参数导入到程序内，然后按start即可直接看到仿真后的数字指标模型和可视化图像，如果想要修改某些参数需先按下restart然后修改文本框，再按下set与start按键
> 注：本程序还存在一些bug（restart前必须保证程序在运行中，没有处于暂停状态（没有按了pause再按restart）），请按照上述操作进行。

## 代码设计经历
1. 因为自身在病毒传播模型这一方面接触较少，首先通过网络搜索学习目前的传染病数学模型：SI、SIS、SIR、SEIR，然后选择SEIR作为这次仿真的数学模型
2. 根据SEIR的微分公式和网上教程通过matlab编写除了一个SEIR模型，并用曲线图体现它的数字指标，模型代码在SEIR_sim.m中。
3. 为了了解到防疫措施对这个模型的影响以及对目前COVID-19在中国传播模型的一个仿真，查阅了几篇该方面的论文，得到了更加细致的模型和经过反演的参数，建立该模型和导入对应参数得到中国目前的疫情情况，与https://www.worldometers.info/coronavirus/进行对比，验证该模型是正确的。（模型代码在Covid_China_sim）。
4. 有了具体的仿真数字指标后，开始建立可视化的模型，首先经过网络搜索，目标确定在了元胞自动机上，然后参考网上的元胞自动机代码，写出了一个比较简单的元胞自动机，代码在cellular_automata_sim中，但后面感觉元胞自动机与新冠传播模型不是很相配，然后在zkw_Covid_visual_sim中改变了传播的代码逻辑。
5. 将上述的防疫模型与传播的代码结合到一起，形成两个图像，分别表示数字指标和可视化传播，然后在这个基础上添加了GUI，然后增加了文本框用于可以在GUI上直接调整参数，然后添加了开始，重启，暂停和继续按钮，控制程序运行状态，从而完成整个代码。

## 代码设计思路
1. 首先给定基本参数，模拟矩阵大小，模型基本人数，个人群人数，感染率，接触人数，康复率。
2. 创建基本GUI界面，包含figure大小位置，button大小位置，用于调整参数的文本框
3. 设置处开始外的其他按钮功能（比较简单的函数）
4. 编写start按钮的函数功能，及主函数功能：首先按照之前建立好的基于在中国的COVID-19传播模型，将真实参数放入SEIR模型中，创建出了中国疫情下的数字指标（曲线图）。
6. 然后创建可视化的传播模型：主要是通过imagesc和一个正方形矩阵来模拟传播过程，矩阵中0表示易感者，1表示康复者，2表示潜伏者，3表示感染者，首先将矩阵中间一个点变为3，表示该场景存在一个
确诊者，然后先设置一个循环，从0到矩阵的行数（len），表示从距离的由近到远开始扫描，每扫描到一个点，如果该点事确诊者或者潜伏者，则扫描其旁边的八个点，然后根据之前的参数（感染率和接触人数）
来计算出相应的患病概率，如果满足概率条件，则相邻的这个变为潜伏者，依次这样循环下去，完成模拟。在循环结束后还要对所有的确诊者和潜伏者进行扫描，同样根据概率条件判断是否变成康复者和潜伏者。
并将更改过的矩阵通过imagesc显示出来。

## 代码结果展示

## 参考
[1]Zhang Liying，LI Dongchen. Analysis of COVID- 19 by Discrete Multi-stage Dynamics System with Time Delay. GeomaticsandInformationScienceofWuhanUniversity. [2020-05].
[2]Yan Yue，Chen Yu，Liu Keji. Modeling and Prediction for the Trend of Outbreak of NCP Based on a Time-Delay Dynamic System ［J/OL］ . Scientia Sinica Mathematica，［2020-04-30］ .
[3]Nonlinear Regression in COVID-19 Forecasting ［J/OL］ . Scientia Sinica Mathematica，2020， 50： 1-12
[4]Tian H Y，Liu Y H，Li Y D. An Investigation of Transmission Control Measures During the First 50 Days of the COVID-19 Epidemic in China［J/OL］Science,［2020-04-30］ . 
[5]https://www.meltingasphalt.com/interactive/going-critical/（传播模型变化参考）
[6]https://blog.csdn.net/qq_40527086/article/details/86798384（元胞自动机代码参考）
[7]https://www.zhihu.com/question/367466399/answer/982558966（病毒传播模型数学建模参考）
[8]https://www.worldometers.info/coronavirus/（COVID-19统计数据参考）
