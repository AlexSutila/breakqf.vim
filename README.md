## BreakQF

Short for **"breakpoint quickfix"**. Easily navigate between [gdb](https://www.gnu.org/savannah-checkouts/gnu/gdb/index.html) breakpoints leveraging vim's native quickfix and tag lists. This plugin should be universal, as long as the target language is supported by both [gdb](https://www.gnu.org/savannah-checkouts/gnu/gdb/index.html) and [ctags](https://github.com/universal-ctags/ctags).

<img width="1438" height="868" alt="image" src="https://github.com/user-attachments/assets/65a31c65-cc14-458b-a8b9-9e7d59432888" />

*****

### Usage
There is kind of an assumption you know how both the quickfix list and taglists already work when using this plugin. That being said this basic plugin provides two commands:

##### Creating tagfile
```
:Mktags
```
- Is a simple wrapper which invokes ctags with the necessary arguments for this plugin to function as intended.

##### Reading breakpoints
```
:ReadBreakpoints <filename>
```
- Is a command which will read the breakpoints from the provided file into the quickfix list.

The breakpoints file is a pre-requisite for running this command. It can be generated within [gdb](https://www.gnu.org/savannah-checkouts/gnu/gdb/index.html) by running the following command:
```
(gdb) save breakpoints <filename>
```

##### Writing breakpoints
```
:WriteBreakpoint <filename>
```
- Is a command which will write the line under the cursor as a breakpoint to the specified file.

The breakpoints file can be either sourced or re-sourced within [gdb](https://www.gnu.org/savannah-checkouts/gnu/gdb/index.html) after running this command. This can be done by running the following command:
```
(gdb) source <filename>
```

After running `ReadBreakpoints` you can use the quickfix list as you traditionally would to navigate between breakpoints.
- `cnext`
- `cprev`
- `copen` (or `cope` if ur based lol)

It will come intuitively if you are already good with the quickfix list.

### Why
It is a subtle but nice thing to have as somebody who spends an enormous amount of time going back and fourth between **vim** and **gdb** during remote work I do through ssh.

The primary reason I write this in **vimscript** and not **lua** is so that it has backwards compatability with vim and older versions when you don't want to be arbitrarily installing editors on other servers *(I'm looking at you neovim elitists)*.

### Todo
- Potentially support a configurable default `breakpoints.txt` that is selected implicitly when no argument is provided.
- Tests.
- Other ideas are welcome as well.
