# Индивидуальное домашнее заданее №2 по предмету Архитектура Вычислительных систем
### Аксенов Даниил, БПИ218, Вариант 29

Разработать программу численного интегрирования функции $y = a + b ∗ x^{−4}$ (задаётся действительными числами а,b) в определённом диапазоне целых (задаётся так же) методом средних (точность вычислений = 0.0001).

## Программа на C

Само решение задачи не вызвало трудностей. Задача проста и понятна По итогу быланаписана не самый оптимальный код на С, который считывает 4 числа, выполняет функцию `integrate` которая вычисляет ответ на задачу методом средних прямоугольников.

Код был разбит на два файла `main.c` и `common.c`, последний содержит функции `integrate` и `calcFunc` которые решают данную задачу.

Дабы получить оценку побольше(7), было добавлено чтение из файла. При запуске программы можно в качестве параметров передать файлы для ввода и вывода. В таком случае  программа прочитает первый файл и запишет ответ во второй.

## Программа на asm
Скомпилировал каждый файл с флагами `-O0 -Wall -masm=intel -S -fno-asynchronous-unwind-tables` и получил два файла `main.s` и `common.s` содержащие 200 строк кода на ассемблере... Приступил к комментированию. Описал полностью работу этого кода. Файлы лежат рядом с readme файлом)


Потом решил получить оценку больше(6 баллов) и добавил использование регистров в при работе с потоками ввода и вывода. Измененный `main.s` лежит внутри папки `modified`

![](/screenshots/refactor_1.png)



### Конечне файлы:
- `main.c` - код программы на языке C

- `common.c` - функции чтения и записи на языке C

- `main.s` - ассемблерный код __с комментариями__, полученный при компиляции `main.c` с флагами `-O0 -Wall -masm=intel -S -fno-asynchronous-unwind-tables`

- `common.s` - ассемблерный код __с комментариями__, полученный при компиляции `common.c` с флагами `-O0 -Wall -masm=intel -S -fno-asynchronous-unwind-tables`

- `modified/main.s` - изменненый код из файла `main.s`, в котором чаще используются регистры

- `staff/main.o` и `staff/common.o` - промежуточные файлы, которые потребовались для генерации запускаемого файла из ассемблерного кода

- `main_std` - скомпилированная программа из `main.c` и `common.c`

- `main_asm` - скомпилированный ассемблерный код из файлов
`modified/main.s` и `common.s`

- в папке `test` лежат тесты и корректные ответы на них

### Тесты

#### Тест 1
Входные данные(`test/input1.txt`):
```
1 1 1 2
```
Ожидаемые выходные данные(`test/output1.txt`):
```
1.291667
```
Результаты тестов:
![](/screenshots/test_base_1.png)
![](/screenshots/test_asm_1.png)
#### Тест 2
Входные данные(`test/input2.txt`):
```
1 0 1 100
```
Ожидаемые выходные данные(`test/output2.txt`):
```
99.000000
```
![](/screenshots/test_base_2.png)
![](/screenshots/test_asm_2.png)

#### Тест 3
Входные данные(`test/inputs3.txt`):
```
0 1 1 1000
```
Ожидаемые выходные данные(`test/output3.txt`):
```
0.333333
```
![](/screenshots/test_base_3.png)
![](/screenshots/test_asm_3.png)