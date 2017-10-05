%  Adds a message to the log box of the GUI.
% input:
% message  The message that will be added to a new line in the log box.

function add(message)
md_GUI = evalin('base', 'md_GUI');
if ~strcmp(message, md_GUI.UI.log_box_string)
	[ md_GUI.UI.log_box_string ] = GUI.multitab.insertCell ( md_GUI.UI.log_box_string, message);
	md_GUI.UI.UImultitab.log_box.String = md_GUI.UI.log_box_string;
	assignin('base', 'md_GUI', md_GUI)
end
end