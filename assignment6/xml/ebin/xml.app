%% Feel free to use, reuse and abuse the code in this file.

{application, xml, [
	{description, "Cowboy xml parse"},
	{vsn, "1"},
	{modules, ['xml_app','xml_sup']},
	{registered, [xml_sup]},
	{applications, [
		kernel,
		stdlib,
		cowboy
	]},
	{mod, {xml_app, []}},
	{env, []}
]}.
