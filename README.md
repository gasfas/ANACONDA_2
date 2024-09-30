# ANACONDA\_2
For installation:
- copy the 'package' folder (included in the repository) to your local system.
- add this folder to the path (only the folder, not the subfolders), either by the command:
	addpath(fullfile('path','to','folder', ...., 'package')). For example: addpath('D:\Software\ANACONDA_2\package')
  or do this by right-clicking on the folder in the file browser in MATLAB, and click 'add to path'.
- if you want to include the package automatically, please write the 'addpath' command in your 'startup.m', like this:
  1. Write 'edit startup.m' in your MATLAB command window
  2. The file should now be open in your MATLAB editor. 
  3. Add the 'addpath' commands in that file. This way, the package is automatically included when you start up MATLAB.

you are now ready to use all functions within the package. 

Use the fs-big GUI (under development) by writing 'GUI.fs_big.main' in your MATLAB command window.

