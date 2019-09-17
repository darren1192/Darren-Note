# shell 从了解到入门 · 基础

###  一、shell 变量

#### 1.1 使用变量

shell 的变量必须遵循如下规则：

- 命名只能使用英文字母，数组和下划线，首个字符不能以数字开头。
- 中间不能有空格，可以使用下划线。
- 不能使用标点符号。
- 不能使用base里的关键字。

举个🌰：

```
YourName="Tom"
your_name="cat"
_yourname="dog"
yourname2="ruth"
```

使用变量要在变量前面加 **$** ，加花括号是为了帮助解释器识别变量边界（可不加）。

```
echo $YourName
echo $your_name
echo ${_yourname}
echo ${yourname2}
```

#### 1.2 只读变量

使用 **readonly** 命令可以将变量定义为只读变量(类似 **Swift** 中的 **let** ，没错，我是一个Swifter)，只读变量的值不能被改变:

```
#!bin/bash
yourname="ruth"
readonly yourname
yourname="tom"
```

运行脚本，报错如下：

```
line 4: yourname: readonly variable
```

#### 1.3 删除变量

使用 **unset** 命令可以删除变量，不能删除只读变量：

```
yourname="ruth"
unset yourname
echo $yourname
```

输出为空。

#### 1.4 变量类型

运行shell时，会同时存在三种变量

- 局部变量：在脚本或命令中定义，仅在当前shell实例中有效。
- 环境变量：所有的程序，包括shell启动的程序，都能访问环境便令，有些程序需要环境变量来保证其正常运行。必要的时候shell脚本也可以定义环境便令。
- shell变量：shell变量是由shell程序设置的特殊变量，有一部分是环境变量，有一部分是局部变量，这些变量保证了shell 的正常运行。

### 二、shell 字符串

上面的举得例子就是字符串，在shell中字符串可以用单引号和双引号或者都不用。

单双引号的区别是：单引号不可以解析变量，双引号可以。

单引号：

- 单引号里的任何字符串都会原样输出，单引号字符串中的变量是无效的。
- 单引号字符串中不能单独出现一个单引号，但可成对出现，作为字符串拼接使用。

双引号：

- 双引号里可以有变量。
- 双引号里可以出现转义字符。

#### 2.1 拼接字符串

```
text="World"
# 使用双引号拼接
echo "hello, $text !"
echo "hello, ${text} !"
# 使用单引号拼接
echo 'hello, '$text' !'
echo 'hello, ${text} !'  #单引号里面的变量是不会解析的
```

输入如下：

```
hello, World !
hello, World !
hello, World !
hello, ${text} !
```

另外，shell还有很多字符串处理方法，这里做一些copy：

```
ABC="my name is tom,his name is cat"
echo "字符串长度=${#ABC}" # 取字符串长度
echo "截取=${ABC:11}" # 截取字符串， 从11开始到结束
echo "截取=${ABC:11:3}" # 截取字符串， 从11开始3个字符串
echo "默认值=${XXX-default}" #如果XXX不存在，默认值是default
echo "默认值=${XXX-$ABC}" #如果XXX不存在，默认值是变量ABC
echo "从开头删除最短匹配=${ABC#my}" # 从开头删除 my 匹配的最短字符串
echo "从开头删除最长匹配=${ABC##my*tom}" # 从开头删除 my 匹配的最长字符串
echo "从结尾删除最短匹配=${ABC%cat}" # 从结尾删除 cat 匹配的最短字符串
echo "从结尾删除最长匹配=${ABC%%,*t}" # 从结尾删除 ,*t 匹配的最长字符串
echo "替换第一个=${ABC/is/are}" #替换第一个is
echo "替换所有=${ABC//is/are}" #替换所有的is
```

运行结果如下：

```
字符串长度=30
截取=tom,his name is cat
截取=tom
默认值=default
默认值=my name is tom,his name is cat
从开头删除最短匹配= name is tom,his name is cat
从开头删除最长匹配=,his name is cat
从结尾删除最短匹配=my name is tom,his name is 
从结尾删除最长匹配=my name is tom
替换第一个=my name are tom,his name is cat
替换所有=my name are tom,hare name are cat
```



### 三、shell 数组

bash支持一维数组，不支持多维数组，没有限定数组大小。

在shell中，用括号来表示数组，数组元素用“空格”符号分割开来。比如：

```
array=(1 2 3 4 5)
```

#### 3.1 读取数组

一开始我以为读取数组只要 **echo array** 就可以了，没想到我太too young too smiple了。在shell中，读取数组元素值的一般格式是：

```
${数组名[下标]}
```

例如：

```
echo ${array[2]}  #3	
```

也可以使用下标来定义数组：

```
array_name[0]="tom"
array_name[1]="cat"
```

使用 **@** 或 ***** 可以获取数组的所有元素:

```
echo ${array[@]} #1 2 3 4 5 
```

获取数组长度：

```
length=${#array[@]}
# 或者
length=${#array[*]}
```

### 四、shell 运算符

Shell 和其他编程语言一样，支持多种运算符:

- 算术运算符
- 关系运算符
- 布尔运算符
- 逻辑运算符
- 字符串运算符
- 文件测试运算符

原生bash不支持简单的数学运算，但是可以同通过其他命令来实现，比如： **awk** 和 **expr** ， **expr**最常用。

**expr** 是一款表达式计算器，使用它能完成表达式的求值操作。

```
val=`expr 1 + 1`   #注意使用的是反引号 ` 而不是单引号 '
echo "$val"
```

输出结果

```
2
```

#### 算术运算符

常用的算术运算符有 **+ - * / % = == !=** 。和其他语言一样，不做过多描述。但有一点要注意，乘号(*)前边必须加反斜杠\才能实现乘法运算。

```
a=10
b=20
val=`expr $a \* $b`
```

#### 关系运算符

| 运算符 | 说明                                                | 举例                      |
| ------ | --------------------------------------------------- | ------------------------- |
| -eq    | 检测两个数是否相等，相等返回true                    | [\$a -eq $b ] 返回 false  |
| -ne    | 检测两个数是否不相等，不相等返回true                | [ \$a -ne $b ] 返回 true  |
| -gt    | 检测左边的数是否大于右边的，如果是，则返回 true     | [ \$a -gt $b ] 返回 fals  |
| -lt    | 检测左边的数是否小于右边的，如果是，则返回 true     | [ \$a -lt $b ] 返回 true  |
| -ge    | 检测左边的数是否大于等于右边的，如果是，则返回 true | [ \$a -ge $b ] 返回 false |
| -le    | 检测左边的数是否小于等于右边的，如果是，则返回 true | [ \$a -le $b ] 返回 true  |

#### 布尔运算符

| 运算符 | 说明 | 举例                                |
| ------ | ---- | ----------------------------------- |
| !      | 非   | [! false] 返回true                  |
| -o     | 或   | [\$a -lt 20 -o $b -gt 100] 返回true |
| -a     | 与   | [\$a -lt 20 -a $b -gt 100] 返回true |

#### 逻辑运算符

和其它编程语言一样， **&& ||** 不多描述

#### 字符串运算符

假设

```
a="abc"
b="efg"
```

| 运算符 | 说明                                    | 举例                    |
| ------ | --------------------------------------- | ----------------------- |
| =      | 检测两个字符串是否相等，相等返回 true   | [ \$a = $b ] 返回 false |
| !=     | 检测两个字符串是否相等，不相等返回 true | [ \$a != $b ] 返回 true |
| -z     | 检测字符串长度是否为0，为0返回 true     | [ -z $a ] 返回 false    |
| -n     | 检测字符串长度是否为0，不为0返回 true   | [ -n "$a" ] 返回 true   |
| $      | 检测字符串是否为空，不为空返回 true     | [ $a ] 返回 true        |

#### 文件测试运算符

文件测试运算符用户检测Unix文件的各种属性

| 运算符  | 说明                                                         |
| :------ | ------------------------------------------------------------ |
| -b file | 检测文件是否是块设备文件，如果是，则返回 true                |
| -c file | 检测文件是否是字符设备文件，如果是，则返回 true              |
| -d file | 检测文件是否是目录，如果是，则返回 true                      |
| -f file | 检测文件是否是普通文件（既不是目录，也不是设备文件），如果是，则返回 true |
| -g file | 检测文件是否设置了 SGID 位，如果是，则返回 true              |
| -k file | 检测文件是否设置了粘着位(Sticky Bit)，如果是，则返回 true    |
| -p file | 检测文件是否是有名管道，如果是，则返回 true                  |
| -u file | 检测文件是否设置了 SUID 位，如果是，则返回 true              |
| -r file | 检测文件是否可读，如果是，则返回 true                        |
| -w file | 检测文件是否可写，如果是，则返回 true                        |
| -x file | 检测文件是否可执行，如果是，则返回 true                      |
| -s file | 检测文件是否为空（文件大小是否大于0），不为空返回 true       |
| -e file | 检测文件（包括目录）是否存在，如果是，则返回 true            |



##### 补充：

- [shell文字颜色](https://misc.flogisoft.com/bash/tip_colors_and_formatting)