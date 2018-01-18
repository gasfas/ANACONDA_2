% Loads a file with the system metadata; system metadata spectrometer is
% selected in a dialogue box.

function exp_md = LoadFile_system_md(md_GUI)
%% Fetch the spectrometer name, by dialog box:
try
    spec_name = GUI.load.IO.dialogues.fetch_spec_name(md_GUI);
    %% Read the metadata from the selected spectrometer:
    exp_md = metadata.defaults.exp.(spec_name).md_all_defaults();
catch
    exp_md = [];
end
end