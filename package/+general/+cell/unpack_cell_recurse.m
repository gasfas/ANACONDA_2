function [ C_unpacked ] = unpack_cell_recurse( C_packed )
% This function checks whether a cell is 'packed in' another cell, and
% checks it recursively.
try iscell(C_packed{:});
	C_unpacked = general.cell.unpack_cell_recurse(C_packed{:});
catch C_unpacked = C_packed;

end

