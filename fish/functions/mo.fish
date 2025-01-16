function mo
#!/usr/bin/env fish

# 获取当前活动窗口的ID
set window_id (wmctrl -l | grep -iE "(tmux|fish)" | awk '{print $1}')


# 获取窗口的几何信息
set window_geometry (xdotool getwindowgeometry $window_id | grep -oP 'Position: \K\d+,\d+')
set window_x (echo $window_geometry | cut -d',' -f1)
set window_y (echo $window_geometry | cut -d',' -f2)

# 获取所有显示器的信息
set screens (xrandr | grep ' connected' | awk '{print $1, $3}')

# 初始化变量
set current_screen ""
set other_screen ""

# 判断窗口位于哪个显示器，并找到另一个显示器
for screen in $screens
    set screen_name (echo $screen | awk '{print $1}')
    set screen_geometry (echo $screen | awk '{print $2}')

    # 如果几何信息是 "primary"，则从 xrandr 的其他输出中提取分辨率
    if test "$screen_geometry" = "primary"
        set screen_geometry (xrandr | grep "$screen_name" | grep -oP '\d+x\d+\+\d+\+\d+')
    end

    # 提取显示器的宽度、高度和偏移量
    set screen_width (echo $screen_geometry | grep -oP '\d+x\d+' | cut -d'x' -f1)
    set screen_height (echo $screen_geometry | grep -oP '\d+x\d+' | cut -d'x' -f2)
    set screen_x (echo $screen_geometry | grep -oP '\+\d+\+\d+' | cut -d'+' -f2)
    set screen_y (echo $screen_geometry | grep -oP '\+\d+\+\d+' | cut -d'+' -f3)

    # 检查变量是否为空
    if test -z "$screen_width" -o -z "$screen_height" -o -z "$screen_x" -o -z "$screen_y"
        echo "错误: 无法解析显示器的几何信息"
        continue
    end

    # 判断窗口是否位于当前显示器范围内
    if test $window_x -ge $screen_x -a $window_x -lt (math "$screen_x + $screen_width") -a \
               $window_y -ge $screen_y -a $window_y -lt (math "$screen_y + $screen_height")
        set current_screen $screen_name
        echo "终端窗口当前位于显示器: $current_screen"
    else
        # 记录另一个显示器
        set other_screen $screen_name
    end
end
# 检查窗口是否处于最大化状态
set is_maximized (xprop -id $window_id| grep '_NET_WM_STATE(ATOM)' | grep -i 'MAXIMIZED')
if test -n "$is_maximized"
    echo "终端窗口处于最大化状态，正在取消最大化..."
    wmctrl -ir $window_id -b remove,maximized_vert,maximized_horz
    set restore_maximized true
else
    echo "终端窗口未处于最大化状态。"
    set restore_maximized false
end

# 如果找到了另一个显示器，则移动窗口
if test -n "$other_screen"
    echo "正在将终端窗口移动到显示器: $other_screen"

    # 获取另一个显示器的几何信息
    set other_screen_geometry (xrandr | grep "$other_screen" | grep -oP '\d+x\d+\+\d+\+\d+')
    set other_screen_x (echo $other_screen_geometry | grep -oP '\+\d+\+\d+' | cut -d'+' -f2)
    set other_screen_y (echo $other_screen_geometry | grep -oP '\+\d+\+\d+' | cut -d'+' -f3)

    # 移动窗口到另一个显示器的左上角
    xdotool windowmove $window_id $other_screen_x $other_screen_y
    echo "窗口已移动到显示器: $other_screen"
else
    echo "未找到另一个显示器，无法移动窗口。"
end

# 如果之前取消了最大化状态，则恢复最大化
if test "$restore_maximized" = "true"
    echo "恢复终端窗口的最大化状态..."
    wmctrl -ir $window_id -b add,maximized_vert,maximized_horz
end
end



