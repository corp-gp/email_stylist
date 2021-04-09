
# Замер производительности

Тестировал командами в консоли:

```require 'benchmark'; ActiveRecord::Base.logger = nil; %w[render_template render_partial render_collection].each { |event| ActiveSupport::Notifications.unsubscribe "#{event}.action_view" };```

```Benchmark.realtime { 10.times { ReminderMailer.r_bookmark_without_li(666084).message } }```

В письме 24 товара.

## Результаты:

### ERB precompiled:

+++ Без кэширования

```
Benchmark.realtime { 10.times { ReminderMailer.r_bookmark_without_li(666084).message } } 
ReminderMailer#r_bookmark_without_li: processed outbound mail in 880.7ms                                 
ReminderMailer#r_bookmark_without_li: processed outbound mail in 781.0ms                                 
ReminderMailer#r_bookmark_without_li: processed outbound mail in 774.3ms                                 
ReminderMailer#r_bookmark_without_li: processed outbound mail in 769.4ms                                 
ReminderMailer#r_bookmark_without_li: processed outbound mail in 780.6ms                                 
ReminderMailer#r_bookmark_without_li: processed outbound mail in 785.7ms                                 
ReminderMailer#r_bookmark_without_li: processed outbound mail in 878.0ms                                 
ReminderMailer#r_bookmark_without_li: processed outbound mail in 952.3ms                                 
ReminderMailer#r_bookmark_without_li: processed outbound mail in 773.4ms                                 
ReminderMailer#r_bookmark_without_li: processed outbound mail in 770.0ms                                 
=> 8.150225899997167                                                                                     
```
+++ С кэшированием

```
Benchmark.realtime { 10.times { ReminderMailer.r_bookmark_without_li(666084).message } }
ReminderMailer#r_bookmark_without_li: processed outbound mail in 413.5ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 421.9ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 429.2ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 417.7ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 417.5ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 418.8ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 441.0ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 422.0ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 433.8ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 424.7ms
=> 4.244122099989909
```

### Render inline:

+++ Без кэширования

```
Benchmark.realtime { 10.times { ReminderMailer.r_bookmark_without_li(666084).message } }
ReminderMailer#r_bookmark_without_li: processed outbound mail in 783.1ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 780.3ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 779.0ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 784.4ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 794.0ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 787.6ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 908.8ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 899.2ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 786.5ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 787.3ms
=> 8.095350000003236
```

+++ C кэшированием:

```
Benchmark.realtime { 10.times { ReminderMailer.r_bookmark_without_li(666084).message } }
ReminderMailer#r_bookmark_without_li: processed outbound mail in 428.5ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 459.1ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 430.2ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 439.0ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 432.2ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 433.6ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 438.0ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 431.5ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 436.8ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 435.3ms
=> 4.368637000006856
```

### Inky templates (то что в проде сейчас):

```
Benchmark.realtime { 10.times { ReminderMailer.r_bookmark_without_li(666084).message } }
ReminderMailer#r_bookmark_without_li: processed outbound mail in 532.9ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 522.1ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 500.5ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 562.2ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 516.5ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 520.4ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 718.0ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 513.5ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 693.4ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 533.3ms
=> 5.61962090000452
```

### Slim templates (то что было раньше)

```
Benchmark.realtime { 10.times { ReminderMailer.r_bookmark_without_li(666084).message } }
ReminderMailer#r_bookmark_without_li: processed outbound mail in 690.6ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 473.2ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 509.0ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 488.8ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 482.9ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 470.7ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 472.6ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 526.3ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 498.5ms
ReminderMailer#r_bookmark_without_li: processed outbound mail in 487.1ms
=> 5.1059754000016255
```
