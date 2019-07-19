## Shell 从入门到入门 · 提高

### 一、shell 流程控制

#### if

##### 1.1 if 语句

if 语句语法格式：

```
if condition
then
    command1 
    command2
    ...
    commandN 
fi
```

写成一句话就是:

```
if [ true ]; then echo "True"; fi
```

##### 1.2 if else 

```
if condition
then
    command1 
    command2
    ...
    commandN
else
    command
fi
```

##### 1.3 if else-if else

```
if condition1
then
    command1
elif condition2 
then 
    command2
else
    commandN
fi
```

逼逼一句：elif突然让我想起来py，真是不习惯。

#### for 循环

```
for var in item1 item2 ... itemN
do
    command1
    command2
    ...
    commandN
done
```

### while 语句

```
while condition
do
    command
done
```

#### Until 循环

**until** 循环执行一系列命令直至条件为 true 时停止，和 **while** 相反。

```
until condition
do
    command
done
```

####  case

```
case 值 in
模式1)
    command1
    command2
    ...
    commandN
    ;;
模式2）
    command1
    command2
    ...
    commandN
    ;;
esac
```

🌰：

```
echo '输入A-D之间的字母:'
echo "你输入的字母为:"
read AA
case $AA in 
    A) echo "你选择了A"
    ;;
    B) echo "你选择了B"
    ;;
    C) echo "你选择了C"
    ;;
    D) echo "你选择了D"
    ;;
esac
```

输出：

``` 
输入A-D之间的字母:
你输入的字母为:
C
你选择了C
```

#### 跳出循环

##### break 和 continue

break命令允许跳出所有循环，continue命令允许跳出当前循环

### shell 函数

shell 可以用户定义函数，然后在shell脚本中可以随便调用

```
[ function ] funname [()]
{
    action;
    [return int;]
}
```

🌰：

```
demoFunc() {
    echo "这是我的一个shell函数"
}

echo "----函数执行----"
demoFunc
echo "----函数结束----"
```

输出：

```
----函数执行----
这是我的一个shell函数
----函数结束----
```

下面是一个带有 **return** 语句的函数:

```
func() {
    echo "输入第一个数字"
    read numOne
    echo "输入第二个数字"
    read numTwo
    return $(($numOne+$numTwo))
}
func 
echo "相加结果 $?"
```

输出结果：

```
输入第一个数字
1
输入第二个数字
2
相加结果 3
```

函数返回值在调用该函数后通过 $? 来获得。

#### 函数参数

在Shell中，调用函数时可以向其传递参数。在函数体内部，通过 $n 的形式来获取参数的值，例如，$1表示第一个参数，$2表示第二个参数...

```
func() {
    echo "第一个参数: $1"
    echo "第二个参数: $2"
    echo "第三个参数: $3"
    echo "第十个参数: $10"
    echo "第十个参数: ${10}"
    echo "参数总数有 $# 个"
    echo "输出所有参数 $* "
}
func 1 2 3 4 5 6 7 8 9 10 11 12
```

输出:

```
第一个参数: 1
第二个参数: 2
第三个参数: 3
第十个参数: 10
第十个参数: 10
参数总数有 12 个
输出所有参数 1 2 3 4 5 6 7 8 9 10 11 12 
```

其中：\$10 不能获取第十个参数，获取第十个参数需要\${10}。当n>=10时，需要使用${n}来获取参数。

### 其他

### ()、(())、[]、[[]]和{}

#### 单小扩号（）

- 命令组 括号中的命令将会新开一个子shell顺序执行，所以括号中的变量不能够被脚本余下的部分使用。括号中多个命令之间用分号隔开，最后一个命令可以没有分号，各命令和括号之间不必有空格。

  ```
  a=1
  (echo "123";a="2";echo "a=$a")
  echo "a=$a"
  ```

  输出：

  ```
  123
  a=2
  a=1
  ```

- 命令替换 发现了\$(cmd)结构，便将$(cmd)中的cmd执行一次，得到其标准输出，再将此输出放到原来命令。

- 用于初始化数组 如：array=(a b c d)

### 双小括号(())

- 运算扩展

  ```
  a=$((4+5))
  echo "a=$a"	#9
  ```

- 做数值运算，重新定义变量

  ```
  a=5
  ((a++))
  echo "a=$a"	#6
  ```

- 用于算术运算比较

  ```
  if ((1+1>1));then
    echo "1+1>1"
  fi
  ```

### 单中括号[]

- 用于字符串比较，需要注意，用于字符串比较，运算符只能是 ==和!=，需要注意，运算符号2边必须有空格，不然结果不正确。

  ```
  if [ "2" == "2" ]
  then 
      echo "相等"
  else 
      echo "不相等"
  fi
  ```

- 用于整数比较 需要注意，整数比较，只能用-eq，-gt这种形式，不能直接使用大于(>)小于(<)符号。只能用于整形

  ```
  if [ 2 -eq 2 ]
  then 
      echo "相等"
  else 
      echo "不相等"
  fi
  ```

### 双中括号[[]]

​	[[]]是 bash 程序语言的关键字。并不是一个命令，[[ ]] 结构比[ ]结构更加通用。

- 字符串匹配时甚至支持简单的正则表达式

  ```
  if [[ "123" == 12* ]]
  then    
      echo "ok"
  fi
  ```

- 支持对数字的判断，是支持浮点型的，并且可以直接使用<、>、==、!=符号

  ```
  if [[  2.1 > 1.1 ]]; then
    echo "ok"
  fi
  ```

- 多个逻辑判断 可以直接使用&&、||做逻辑运算，并且可以在多个[[]]之间进行运算

  ```
  if [[  1.1 > 1.1 ]] || [[ 1.1 == 1.1 ]]; then
    echo "ok"
  fi
  ```

### 大括号{}

- 统配扩展

  ```
  touch new_{1..5}.txt #创建new_1.txt	new_2.txt	new_3.txt	new_4.txt	new_5.txt  5个文件
  ```


### 其他用法

