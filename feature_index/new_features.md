# 新增功能索引

> **更新时间**: 2026-02-07  
> **版本**: v2.0  
> **新增功能**: 6个创新模块

---

## 1. 每日挑战任务系统

### 类名: `PourRichDailyTasksLogic`
**路径**: `lib/pages/pour_rich_daily_tasks/`  
**功能**: 每日任务管理,完成任务获得金币

**核心方法**:
- `loadData()`: 加载今日任务和金币余额
- `checkTaskProgress(taskKey, progress)`: 更新任务进度
- `generateDailyTasks()`: 自动生成每日任务

**数据库**:
- 表: `daily_tasks`
- 实体: `DailyTask`

**使用示例**:
```dart
// 在游戏逻辑中更新任务进度
final tasksLogic = Get.find<PourRichDailyTasksLogic>();
await tasksLogic.checkTaskProgress('monopoly_guess_5', 5);
```

---

## 2. 储蓄挑战金库

### 类名: `PourRichSavingsLogic`
**路径**: `lib/pages/pour_rich_savings/`  
**功能**: 储蓄目标设定和追踪

**核心方法**:
- `createGoal()`: 创建储蓄目标
- `depositToGoal(goal, amount, note)`: 存款到目标
- `loadGoals()`: 加载所有目标

**数据库**:
- 表: `savings_goals`, `savings_records`
- 实体: `SavingsGoal`, `SavingsRecord`

**使用示例**:
```dart
// 创建储蓄目标
await logic.createGoal(
  name: 'Buy iPhone',
  targetAmount: 1000.0,
  description: 'Save for new phone',
);
```

---

## 3. 冷知识问答模式

### 类名: `PourRichQuizLogic`
**路径**: `lib/pages/pour_rich_quiz/`  
**功能**: 问答挑战,测试知识获得金币

**核心方法**:
- `loadQuestion()`: 加载问题
- `selectOption(option)`: 选择答案
- `submitAnswer()`: 提交答案
- `nextQuestion()`: 下一题

**数据库**:
- 表: `trivia_questions`, `quiz_history`
- 实体: `TriviaQuestion`, `QuizHistory`

**使用示例**:
```dart
// 加载问题并答题
final quizLogic = Get.find<PourRichQuizLogic>();
quizLogic.selectOption(2);
await quizLogic.submitAnswer();
```

---

## 4. 成就勋章系统

### 类名: `PourRichAchievementsLogic`
**路径**: `lib/pages/pour_rich_achievements/`  
**功能**: 全局成就管理和展示

**核心方法**:
- `loadAchievements()`: 加载成就列表
- `selectCategory(category)`: 按类别筛选
- `getRarityColor(rarity)`: 获取稀有度颜色

**数据库**:
- 表: `global_achievements`
- 实体: `GlobalAchievement`
- 方法: `unlockGlobalAchievement(key)`

**成就类别**:
- monopoly: 倒水大富翁成就
- challenge: 倒水挑战成就
- trivia: 冷知识成就
- financial: 理财成就
- global: 全局成就

**使用示例**:
```dart
// 检查并解锁成就
await _db.checkAndUnlockAchievements();
// 或手动解锁
await _db.unlockGlobalAchievement('first_win');
```

---

## 5. 数据统计仪表盘

### 类名: `PourRichStatsLogic`
**路径**: `lib/pages/pour_rich_stats/`  
**功能**: 可视化展示所有游戏数据

**核心方法**:
- `loadStats()`: 加载所有统计数据
- 计算属性: `challengeSuccessRate`, `quizAccuracy`, `achievementProgress`

**展示数据**:
- 金币总额
- 游戏表现(大富翁、倒水挑战)
- 学习进度(冷知识、问答)
- 理财目标
- 成就进度

**使用示例**:
```dart
// 查看统计
Get.toNamed('/stats');
```

---

## 6. 理财计算器工具箱

### 类名: `PourRichCalculatorLogic`
**路径**: `lib/pages/pour_rich_calculator/`  
**功能**: 4合1理财计算工具

**计算器类型**:
1. **复利计算器**: 计算投资本息
2. **房贷计算器**: 计算月供和总利息
3. **退休金计算器**: 估算养老金需求
4. **理财目标计算器**: 计算达成时间

**核心方法**:
- `calculateCompoundInterest()`: 复利计算
- `calculateMortgage()`: 房贷计算
- `calculateRetirement()`: 退休金计算
- `calculateGoal()`: 目标时间计算

**使用示例**:
```dart
// 复利计算
controller.principalController.value = '10000';
controller.annualRateController.value = '5';
controller.yearsController.value = '10';
controller.calculateCompoundInterest();
// 结果: controller.compoundResult.value
```

---

## 金币系统

### 类名: `PourRichDatabase` (新增方法)
**路径**: `lib/db_pour_rich/data.dart`

**金币操作**:
- `getCoinsBalance()`: 获取金币余额
- `addCoins(amount, source, description)`: 增加金币
- `deductCoins(amount, source, description)`: 扣除金币
- `getCoinsRecords(limit)`: 获取金币记录

**金币来源**:
- `task`: 每日任务
- `quiz`: 问答正确
- `achievement`: 成就解锁

**数据库表**:
- `user_coins`: 用户金币余额
- `coins_records`: 金币变动记录

---

## 数据库扩展

### 新增实体类
**路径**: `lib/db_pour_rich/db_pour_rich_entity.dart`

1. `DailyTask` - 每日任务
2. `SavingsGoal` - 储蓄目标
3. `SavingsRecord` - 储蓄记录
4. `TriviaQuestion` - 问答题目
5. `QuizHistory` - 问答记录
6. `CoinsRecord` - 金币记录
7. `GlobalAchievement` - 全局成就

### 数据库版本升级
- 版本: v1 -> v2
- 迁移方法: `_onUpgrade()`
- 新增8个表
- 自动初始化数据

---

## 路由配置

**路径**: `lib/router/pour_rich_index.dart`

新增路由:
```dart
'/features'       -> PourRichFeaturesView (功能总览)
'/daily_tasks'    -> PourRichDailyTasksView
'/savings'        -> PourRichSavingsView
'/quiz'           -> PourRichQuizView
'/achievements'   -> PourRichAchievementsView
'/stats'          -> PourRichStatsView
'/calculator'     -> PourRichCalculatorView
```

---

## 依赖包

**新增依赖**:
```yaml
fl_chart: ^0.69.0    # 图表库
intl: ^0.19.0        # 日期格式化
```

---

## 使用流程

### 1. 每日任务流程
```dart
// 1. 自动生成任务(每天首次打开APP)
await _db.generateDailyTasks();

// 2. 在游戏中更新进度
await tasksLogic.checkTaskProgress('monopoly_guess_5', currentProgress);

// 3. 达成目标自动完成任务并发放金币
// 4. 检查成就
await _db.checkAndUnlockAchievements();
```

### 2. 储蓄目标流程
```dart
// 1. 创建目标
await savingsLogic.createGoal(name: '...', targetAmount: 1000);

// 2. 存款
await savingsLogic.depositToGoal(goal, 50.0, 'Weekly savings');

// 3. 自动检查是否完成
// 4. 完成后解锁成就
```

### 3. 问答流程
```dart
// 1. 加载问题(优先未答过的)
await quizLogic.loadQuestion();

// 2. 用户选择答案
quizLogic.selectOption(1);

// 3. 提交答案
await quizLogic.submitAnswer();

// 4. 显示结果,答对+10金币
// 5. 下一题
await quizLogic.nextQuestion();
```

---

## 注意事项

1. **数据库升级**: 首次运行会自动升级数据库到v2
2. **金币系统**: 所有金币操作自动记录到coins_records表
3. **成就检测**: 在关键操作后调用`checkAndUnlockAchievements()`
4. **任务更新**: 需在游戏Logic中手动调用`checkTaskProgress()`
5. **问答题库**: 目前仅10题,建议扩展

---

## 快速接入指南

### 在现有游戏中接入任务系统

#### 倒水大富翁页面:
```dart
// 猜对水量时
final tasksLogic = Get.find<PourRichDailyTasksLogic>();
await tasksLogic.checkTaskProgress('monopoly_guess_5', correctGuessCount);
```

#### 倒水挑战页面:
```dart
// 挑战成功时
final tasksLogic = Get.find<PourRichDailyTasksLogic>();
await tasksLogic.checkTaskProgress('challenge_win_3', successCount);
```

#### 冷知识页面:
```dart
// 阅读冷知识时
final tasksLogic = Get.find<PourRichDailyTasksLogic>();
await tasksLogic.checkTaskProgress('trivia_read_5', readCount);
```

---

## 完成清单

- [x] 数据库设计与实现
- [x] 6个功能模块完整实现
- [x] UI界面开发
- [x] 路由配置
- [x] 金币系统集成
- [x] 成就系统集成
- [x] 设置页面入口
- [x] 功能文档编写

**开发状态**: ✅ 全部完成  
**测试状态**: ⏳ 待测试  
**上线状态**: ⏳ 待发布
