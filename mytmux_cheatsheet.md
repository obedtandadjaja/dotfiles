# Tmux Cheatsheet

Prefix is `<ctrl> <space>`

- List of keyboard shortcuts `<prefix> ?`
- Open editor `<prefix> e`
- Reload config `<prefix> r`

## Managing sessions

Creating a session:

```
tmux new-session -s work
```

Duplicate a session

```
tmux new-session -s work2 -t work
```

Attach to a session

```
tmux attach -t work
```

Detach from a session

```
<leader> d
```

Switch between sessions

```
<leader> (     previous
<leader> )     next
<leader> s     list all sessions and choose
```

Other

```
<leader> $     rename session
```

## Managing windows

Create a window

```
<leader> c
```

Switch between windows

```
<leader> 1..9
<leader> p     previous window
<leader> n     next window
<leader> l     last window
<leader> w     list all windows and choose
```

Other

```
<leader> ,     rename current window
<leader> &     delete current window
```

## Managing panes

```
<leader> "     split vertically       <leader> /
<leader> %     split horizontally     <leader> -
```

Switching panes

```
<leader> left|right|up|down
<leader> o                      go to the next pane
<leader> ;                      go to last pane
```

Moving panes around

```
<leader> {         move current pane to prev position
<leader> }         move current pane to next position
<leader> !         move the current pane into a new separate window
```

Other

```
<leader> x         kill current pane
<leader> q         display pane numbers
```

## Copy-Paste

There are several ways to do this:

1. TMUX only clipboard

```
# To copy / select using mouse
1. Enter mouse mode - <leader> m
2. Click and drag

# To copy / select using copy-mode
1. Enter copy mode - <leader> enter
2. Select region with `v`
3. Yank with `y`

# To paste
1. Get out of copy mode if you are still in it
2. <leader> p
3. Alternatively, you can also do <leader> ], which is the tmux default
```

2. OS clipboard - Mac OSX tested

```
# To copy / select using mouse
1. Enter mouse mode - <leader> m
2. While holding SHIFT, click and drag - this does normal selection of text
3. CMD + c

# To paste
1. CMD + v
```

## Paste buffer

```
<leader> b        See all buffers
<leader> p        Paste from the top paste buffer
<leader> P #      Choose which buffer to paste from
```
