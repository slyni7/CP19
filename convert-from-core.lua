dofile("expansions/convert-from-core-constant.lua")
dofile("expansions/convert-from-core-proc_fusion.lua")
dofile("expansions/convert-from-core-proc_link.lua")
dofile("expansions/convert-from-core-proc_pendulum.lua")
if IREDO_COMES_TRUE==nil then
	dofile("expansions/convert-from-core-proc_procs.lua")
end
dofile("expansions/convert-from-core-proc_ritual.lua")
dofile("expansions/convert-from-core-proc_synchro.lua")
dofile("expansions/convert-from-core-proc_xyz.lua")
dofile("expansions/convert-from-core-utility.lua")