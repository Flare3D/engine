-- ================================================================================
--
--	FLARE3D Inc.
--	Copyright 2014 Flare3D Inc.
--	All Rights Reserved.
--
--	NOTICE: Flare3D permits you to use, distribute and modify this file
--	in accordance with the terms of the license agreement accompanying it.
--
-- ================================================================================

global flare3d_ini_file = ( getdir #temp + "\flare3d.ini" )
global f3d_arr_selection;
global f3d_plugin_version = "2.7.2"

plugin modifier F3DAnimation name:"F3D Animation Labels" classID:#(685325,452282) version:2 (
	local selected = -1
	
	parameters params rollout:main
	(
		labels type:#stringTab tabsizevariable:true
		lFrom type:#stringTab tabsizevariable:true
		lTo type:#stringTab tabsizevariable:true
		lPlay type:#boolTab  tabsizevariable:true
		lLoop type:#boolTab  tabsizevariable:true
	)
	
	rollout input "Add label" height:360
	(
		local changed = false
		
		edittext lbl "Label" fieldwidth:62 align:#right width:130		
		spinner sfrom "From" type:#integer range:[animationrange.start,animationrange.end,animationrange.start] fieldwidth:40 across:2
		spinner sTo "To" type:#integer range:[animationrange.start,animationrange.end,animationrange.end] fieldwidth:40		
		checkbox play "Autoplay" checked:false align:#left
		checkbox loop "Loop" checked:true align:#left
		button ok "Ok" across:2 align:#center width:60 offset:[0,5]
		button cancel "Cancel" align:#center width:60 offset:[0,5]
		
		on input open do (
			if selected != -1 then (
				lbl.text = labels[ selected ]
				sfrom.value = lfrom[ selected ] as integer
				sto.value = lto[ selected ] as integer
				play.checked = lPlay[ selected ]
				loop.checked = lLoop[ selected ]				
			)
			setFocus lbl
		)
		
		on cancel pressed do destroydialog input
			
		on ok pressed do (	
			if selected == -1 then (
				append labels ( lbl.text )
				append lfrom ( sfrom.value as string )
				append lto ( sto.value as string )
				append lPlay ( play.checked )
				append lLoop ( loop.checked )
			) else (
				labels[ selected ] = lbl.text
				lfrom[ selected ] = sfrom.value as string
				lto[ selected ] = sto.value as string
				lPlay[ selected ] = play.checked
				lLoop[ selected ] = loop.checked
			)
			changed = true
			destroydialog input
		)
	)
	
	rollout main "Labels Parameters"
	(
		label l0 "Label" across:3 align:#center
		label l1 "From"  align:#center
		label l2 "To"  align:#center
		listbox l "" across:3 width:48
		listbox f ""  width:48 enabled:false selection:-1
		listbox t ""  width:48 enabled:false selection:-1
		
		button add "Add" across:2 align:#center width:60
		button remove "Remove" align:#center width:60
		
		function showVars = (
			l.items = labels as array
			f.items = lfrom as array
			t.items = lto as array
		)
		
		on add pressed do (
			selected = -1
			createdialog input modal:true
			if input.changed == true then l.selection = labels.count
			showVars()
		)
		
		on l doubleclicked sel do (
			selected = sel
			createdialog input modal:true
			showVars()
		)
		
		on remove pressed do
		(
			if labels.count > 0 then 
			(
				deleteitem labels l.selection
				deleteitem lfrom l.selection
				deleteitem lto l.selection				
				deleteitem lPlay l.selection	
				deleteitem lLoop l.selection
				
				showVars()				
				if l.selection == 0 then l.selection = labels.count
			)
		)
		
		on main open do
		(
			showVars()
			removerollout input
		)
	)
	
	on load  do
	(
		-- version 2
		if lPlay.count == 0 then
		(
			for i = 1 to labels.count do
			(
				lPlay[i] = false
				lLoop[i] = true
			)
		)
	)
)
plugin modifier F3DRender name:"F3D Render" classID:#(0x6555be7c, 0x2ba53976) version:1 (
	parameters main rollout:params
	(
		priority type:#integer animatable:false ui:pri
	)
	
	rollout params "Render Parameters"
	(
		spinner pri "Layer: " range:[-10000, 10000, 0] type:#integer
	)
)
plugin modifier F3DUserData name:"F3D User Data" classID:#(0x1666cdfe, 0x7f2279c4) version:1 (
	local selected = -1
	
	parameters params rollout:main
	(
		variables type:#stringTab tabsizevariable:true
		values type:#stringTab tabsizevariable:true
		types type:#stringTab tabsizevariable:true
		typIndex type:#indexTab tabsizevariable:true
	)
	
	rollout input "Add variable"
	(
		local changed = false
		
		edittext var "Variable Name" fieldwidth:182 align:#right offset:[0,5]
		edittext val "Value" fieldwidth:182 align:#right
		label l0 "Type" across:2 align:#left offset:[65,2]
		dropdownlist type "" width:182 align:#right items:#("String","Number","Int","Uint","Object","Array")
		
		button ok "Ok" across:2 align:#center width:120 offset:[0,5]
		button cancel "Cancel" align:#center width:120 offset:[0,5]
		
		on input open do (
			if selected != -1 then (
				var.text = variables[ selected ] as string
				val.text = values[ selected ] as string
				type.selection = typIndex[ selected ] as integer
			)
			setFocus var
		)
		
		on cancel pressed do destroydialog input
			
		on ok pressed do (	
			if selected == -1 then (
				append variables var.text
				append values val.text
				append types type.text	
				append typIndex type.selection
			) else (
				variables[ selected ] = var.text
				values[ selected ] = val.text
				types[ selected ] = type.text
				typIndex[ selected ] = type.selection
			)
			changed = true
			destroydialog input
		)
	)
	
	rollout main "User Data Parameters" 
	(
		label l0 "Var" across:3 align:#center
		label l1 "Value"  align:#center 
		label l2 "Type"  align:#center
		listbox lvar "" across:3 width:48
		listbox lval ""  width:48 enabled:false selection:-1
		listbox ltyp ""  width:48 enabled:false selection:-1
		
		button add "Add" across:2 align:#center width:60
		button remove "Remove" align:#center width:60
		
		function showVars = (
			lvar.items = variables as array
			lval.items = values as array
			ltyp.items = types as array
		)
		
		on add pressed do (
			selected = -1
			createdialog input modal:true width:300
			if input.changed == true then lvar.selection = variables.count
			showVars()
		)
		
		on lvar doubleclicked sel do (
			selected = sel
			createdialog input modal:true width:300
			showVars()
		)
		
		on remove pressed do
		(
			if variables.count > 0 then 
			(
				deleteitem variables lvar.selection
				deleteitem values lvar.selection
				deleteitem types lvar.selection	
				deleteitem typIndex lvar.selection
				showVars()				
				if lvar.selection == 0 then lvar.selection = variables.count
			)
		)
		
		on main open do
		(
			showVars()
			removerollout input
		)
	)
)
plugin texturemap Flare3DCubeMapTexture name:"Flare3D CubeMap" classID:#(0x38b86468, 0x2d6d484a) extends:BitmapTexture replaceui:true version:1 (
	
	parameters params rollout:main
	(
		bitmap type:#bitmap animatable:false
		
		on bitmap set val do (
			if val != undefined then delegate.bitmap = val;
		)
	)
	
	rollout main "Main"
	(
		label l "Bitmap:" align:#left offset:[0,3] across:2
		button tex "None" width:260 align:#right
		button view "View Image";
		
		on tex pressed do (
			bmp = selectBitmap()
			if bmp != undefined then (
				bitmap = bmp;
				tex.caption = bitmap.filename;
			)
		)
		
		on view pressed do
		(
			if bitmap != undefined then display bitmap;
		)
		
		fn init = (
			if bitmap != undefined then (
	 			tex.caption = bitmap.filename;
	 			tex.tooltip = bitmap.filename;
			)
			else (
	 			tex.caption = "None";
	 			tex.tooltip = "None";
			)
		)
		
		on main reload do init();
		on main open do init();
	)
)

f3d_lightmaps = (
	
	totalArea = 0;

	function doUVWs obj = (
		
		max modify mode
		
		unwrapMod = unwrap_UVW()	
		unwrapMod.setAlwaysEdit false
		unwrapMod.setMapChannel 3
		unwrapMod.setFlattenAngle 45 --flattenAngle 
		unwrapMod.setFlattenSpacing 0.02 --flattenSpacing 
		unwrapMod.setFlattenNormalize true
		unwrapMod.setFlattenRotate true --flattenRotate 
		unwrapMod.setFlattenFillHoles true --flattenFillHoles 
		unwrapMod.setApplyToWholeObject true
		unwrapMod.name = "Flare3D LightMap UVs"
		unwrapMod.setDebugLevel 0

		with undo off select obj;
		
		addModifier obj unwrapMod;
		
		unwrapMod.flattenMapByMatID 45 0.002 true 2 true true;
		
		return true;
	)

	function doMaps obj quality minSize maxSize path = 
	(
		JPEG.setQuality quality;
		
		objID = finditem (objects as array) obj;
		
		file = (path + "/" + objID as string + "_" + obj.name + "_lightmap.jpg");
		
		local mesh = snapshotAsMesh obj;
		local area = sqrt(meshop.getFaceArea mesh #all);
		local nPix = area * maxSize / totalArea;
		
		-- powers of 2?
		local nPower = 0;
		local n = nPix;
		
		while n >= 2 do ( n /= 2; nPower += 1;  )
		
		-- nPix is between 2 to nPower & 2 to nPower+1, which is closer?
		if (nPix - 2 ^ nPower) <= (2 ^ (nPower+1) - nPix) then
			nPix = 2 ^ nPower
		else
			nPix = 2 ^ (nPower + 1)
		
		if nPix < minSize then nPix = minSize;
		
		lm = lightingMap();
		lm.outputSzX = nPix;
		lm.outputSzY = nPix;
		lm.fileType = file;
		lm.fileName = filenameFromPath lm.fileType;

		-- setting bake elements
		obj.INodeBakeProperties.removeAllBakeElements() 
		obj.INodeBakeProperties.addBakeElement lm --add second element
		obj.INodeBakeProperties.bakeEnabled = true --enabling baking
		obj.INodeBakeProperties.bakeChannel = 3 --channel to bake
		obj.INodeBakeProperties.nDilations = 1 --expand the texture a bi	 

		with undo off select obj;

		render rendertype:#bakeSelected vfb:off progressBar:true cancelled:&wasCancelled outputSize:[nPix,nPix]
		
		if wasCancelled do return false;

		if obj.material == undefined then obj.material = standard diffuse:obj.wireColor;
		
		local map = bitmaptexture filename:file;
		map.coords.mapChannel = 3;
		
		function getMatRef obj = (
			if classof obj.material == standard then return obj.material;
			if classof obj.material == multimaterial then return obj.material;
			if classof obj.material == shell_material then return obj.material.originalMaterial;
			if classof obj.material == blend then return obj.material.map1;
			return undefined;
		)
		obj.material = shell_material name:obj.name originalMaterial:(getMatRef obj) bakedMaterial:(standard name:file diffuseMap:map);
		
		return true;
	)

	function hasUVW obj = (
		local ret;
		for m in obj.modifiers do (
			if classof m == unwrap_UVW and m.name == "Flare3D LightMap UVs" then ret = m;
		)
		if ret != undefined then return true;
		return false;
	)

	function doLightMaps nodes: minSize:32 maxSize:1024 quality:80 path:(getdir #temp) = (
		
		arr = nodes -- as array; -- for a in nodes collect a;
		
		-- get total area.
		totalArea = 0;
		for obj in objects do (
			if superClassOf obj == GeometryClass and classof obj != targetObject then (
				local mesh = snapshotAsMesh obj;
				local area = meshop.getFaceArea mesh #all;
				totalArea += area;
			)
		)
		totalArea = sqrt(totalArea);
		
		-- do the job!
		for obj in arr do (
			if superClassOf obj == GeometryClass and classof obj != targetObject then (
				if hasUVW obj == false then 
				(
					hasUVW obj;
					doUVWs obj;
				)
				if doMaps obj quality minSize maxSize path == false then return false;
			)
		)
	)
)

f3d_plugin_v2 = (

superPath = "";
superFileName = "";
surfID = 0;
animationRangeStart = animationRange.start;
animationRangeEnd = animationRange.end;
skipFrames = 1;
	
function getINIValue section key default = (
	result = getINISetting flare3d_ini_file section key;
	if result == "" then result = default;
	return result;
)
	
function f3d_saveDialog types:"All types (*.*)|*.*" = (	
	file = getINISetting flare3d_ini_file "values" types;
	fname = GetSaveFileName filename:file types:types;
	if fname != undefined do setINISetting flare3d_ini_file "values" types fname;
	return fname;
)

function createDataFile file = (
	stream = fopen ( superPath + file ) "wbcST";
	return stream;
)
	
struct dictionary (
	keys = #(),
	values = #(),
	function add key value = (
		if appendIfUnique keys key == true then
			append values value;
		return value;
	),
	function get key = (
		index = finditem keys key;
		if index > 0 then return values[index];
		return undefined;
	),	
	function getIndex key = (
		return findItem keys key - 1;
	)
)

struct xChunk (
	name,
	text = "",
	attr = #(),
	nodes = #(),
	
	function addAttribute name value = (	
		append attr name;
		append attr value;
	),
	
	function addNode node = (
		append nodes node;
		return node;
	),
	
	function addNodeAt node index = (
		insertitem node nodes (index + 1);
		return node;
	),
	
	function write stream l:0 = (
		attrStr = "";
		space = "";
		
		for i = 1 to l do space += "\t"
		for i = 1 to attr.count by 2 do attrStr += " " + attr[i] + "=\"" + (attr[i+1] as string) + "\"";
		
		if nodes.count > 0 then (
			format "%<%%>\n" space name attrStr to:stream
			for e = 1 to nodes.count do nodes[e].write stream l:(l+1);
			format "%</%>\n" space name to:stream
		) 
		else if text != "" then (
			format "%<%%>%</%>\n" space name attrStr text name to:stream
		) 
		else
			format "%<%%/>\n" space name attrStr to:stream
	)
)

struct surf ( 
	node, matID, id,
	sizePerVertex = 8,
	filename = (id as string),
	vertex = createDataFile (filename + ".vertex"),
	count = 0,
	function close = ( 
		length = ftell vertex;
		fclose vertex;
		if length == 0 then (
			deletefile (superPath + filename + ".vertex");
			vertex = undefined;
		)
	),
	function init = (
		surfID += 1;
	), constructor = init();
)

struct f3d_exporter (
	
	stream,
	root,
	version = 30,
	totalBones = 4,
	activeCamera = undefined,
	onlyAnimations = false,
	exportAnimations = true,
	exportHidden = true,
	exportAsInvisible = true,
	exportViewportCamera = true,
	textureMode = 1,
	textureQuality = 80,
	nodeID = 0,
	
	_animations = dictionary(),
	_materials = dictionary(),
	_instances = dictionary(),
	_surfaces = dictionary(),
	_maps = dictionary(),
	_modifiers = dictionary(),
	_splines = #(),
	_nodes = #(),
	
	function parseFileName file = (
		return ( getfilenamefile file + getfilenametype file )
	),
	
	function getFileName file = (		
		if doesFileExist file == true then return file;			
		if doesFileExist (maxFilePath + parseFileName file) == true then return (maxFilePath + parseFileName file);
		path = mapPaths.getFullFilePath file;
		if doesFileExist path == true then return path;
		return (parseFileName file)
	),

	function writeMatrix3D transform node = (
		if superclassof node == camera then prerotatex transform -90;		
		if classof node == target_light then prerotatex transform -90;	
		if classof node == Directionallight then prerotatex transform -90;
		if classof node == TargetDirectionallight then prerotatex transform -90;
		if classof node == targetSpot then prerotatex transform -90;
		if classof node == freeSpot then prerotatex transform -90;
		s  = (transform.row1.x as string + ",");
		s += (transform.row1.z as string + ",");
		s += (transform.row1.y as string + ",");
		s += (transform.row3.x as string + ",");
		s += (transform.row3.z as string + ",");
		s += (transform.row3.y as string + ",");
		s += (transform.row2.x as string + ",");
		s += (transform.row2.z as string + ",");
		s += (transform.row2.y as string + ",");
		s += (transform.row4.x as string + ",");
		s += (transform.row4.z as string + ",");
		s += (transform.row4.y as string);
	),
	
	function writeTransform transform node str = (		
		if superclassof node == camera then prerotatex transform -90			
		if classof node == target_light then prerotatex transform -90			
		if classof node == Directionallight then prerotatex transform -90
		if classof node == TargetDirectionallight then prerotatex transform -90			
		if classof node == targetSpot then prerotatex transform -90		
		if classof node == freeSpot then prerotatex transform -90
		writeFloat str transform.row1.x
		writeFloat str transform.row1.z
		writeFloat str transform.row1.y
		writeFloat str transform.row3.x
		writeFloat str transform.row3.z
		writeFloat str transform.row3.y
		writeFloat str transform.row2.x
		writeFloat str transform.row2.z
		writeFloat str transform.row2.y
		writeFloat str transform.row4.x
		writeFloat str transform.row4.z
		writeFloat str transform.row4.y
	),
	
	function getInstances node = (
		InstanceMgr.GetInstances node &rptInstances;
		return for n in rptInstances where (areNodesInstances node n) collect n;
	),
	
	function writeBounds node xNode = (
		hasSkin = false;
		for modifier in node.modifiers do (
			if classof modifier == skin then hasSkin = true;
		)
		
		local bounds = nodeGetBoundingBox node node.transform;
		local center = (bounds[2] + bounds[1]) * 0.5;		
		sMin = bounds[1].x as string + "," + bounds[1].z as string + "," + bounds[1].y as string;
		sMax = bounds[2].x as string + "," + bounds[2].z as string + "," + bounds[2].y as string;
		sCenter = center.x as string + "," + center.z as string + "," + center.y as string;
		xNode.addAttribute "min" sMin;
		xNode.addAttribute "max" sMax;
		xNode.addAttribute "center" sCenter;
		xNode.addAttribute "radius" (length(bounds[1] - center));
	),
	
	function writeAnimation node xNode = (
		
		if node.isAnimated == false then return -1;
			
		if _animations.get node == undefined then (
			
			filename = (superFileName + (_animations.values.count) as string);
			
			x = _animations.add node (xchunk "animation");
			x.addAttribute "id" (_animations.getIndex node);
			x.addAttribute "source" filename;
			x.addAttribute "format" "float3x4";
			anim = createDataFile (filename + ".animation");
			
			for t = animationRangeStart to animationRangeEnd by skipFrames do
			(
				at time t transform = node.transform				
				if node.parent != undefined do transform = transform * ( inverse ( at time t node.parent.transform ) )				
				writeTransform transform node anim;
			)
			
			fclose anim;
		)
		return _animations.getIndex node;
	),
	
	function writeParamAnimation node = (
		
		filename = (superFileName + "_" + (_animations.values.count) as string);
		
		x = _animations.add node (xchunk "animation");
		x.addAttribute "id" (_animations.getIndex node);
		x.addAttribute "source" filename;
		x.addAttribute "format" "float1";
		anim = createDataFile (filename + ".animation");
		
		for t = animationRangeStart to animationRangeEnd by skipFrames do writefloat anim ( at time t *node )
		
		fclose anim;
		
		return _animations.getIndex node;
	),
	
	function writeMap map = (
	
		if classof map == normal_bump then map = map.normal_map;			
			
		if _maps.get map == undefined then 
		(
			x = _maps.add map (xchunk "map");
			x.addAttribute "id" (_maps.values.count - 1);
			
			try (
				if classof map == BitmapTexture then (
					coords = map.coords;
					c = x.addNode (xchunk "uOffset");
					c.addAttribute "value" coords.u_offset;
					if coords.u_offset.isanimated == true then c.addAttribute "animation" (writeParamAnimation & coords.u_offset);
					c = x.addNode (xchunk "vOffset");
					c.addAttribute "value" coords.v_offset;
					if coords.v_offset.isanimated == true then c.addAttribute "animation" (writeParamAnimation & coords.v_offset);
					c = x.addNode (xchunk "uRepeat");
					c.addAttribute "value" coords.u_tiling;
					if coords.u_tiling.isanimated == true then c.addAttribute "animation" (writeParamAnimation & coords.u_tiling);
					c = x.addNode (xchunk "vRepeat");
					c.addAttribute "value" coords.v_tiling;
					if coords.v_tiling.isanimated == true then c.addAttribute "animation" (writeParamAnimation & coords.v_tiling);
					bmp = map.bitmap;
					x.addAttribute "type" "rgba";
					x.addAttribute "channel" (map.coords.mapChannel - 1);					
					if map.filtering == 0 or map.filtering == 1 then x.addAttribute "filter" "linear";
					if map.filtering == 2 then x.addAttribute "filter" "nearest";
				)
				else if classof map == Flare3DCubeMapTexture then (
					bmp = map.bitmap;
					x.addAttribute "type" "cubemap";
				)
				else if classof map == Vertex_Color then (
					x.addAttribute "type" "vertexColors";
					x.addAttribute "channel" map.map;
				)
			) catch ()
			
			if bmp != undefined then (
				local ext = toLower( getFilenameType bmp.filename )				
				if ext == ".jpg" or ext == ".png" then (
					if tolower ( getFileNamePath bmp.filename ) != superPath then (	
						deletefile ( superPath + parseFileName bmp.filename )
						copyfile ( getFileName bmp.filename ) ( superPath + (parseFileName bmp.filename) )
					)
				)
				else (
					JPEG.setQuality textureQuality
					local dest = bitmap bmp.width bmp.height
					
					if IDisplayGamma.colorCorrectionMode == #gamma then (
						dest.gamma = IDisplayGamma.gamma;
					)
					
					local ext = ".jpg";
					if textureMode == 2 then ext = ".png";
					dest.filename = (superPath + (getfilenamefile bmp.filename) + ext)
					copy bmp dest;
					save dest;
					close dest;
					bmp = dest;
				)
				x.addAttribute "source" (parseFileName bmp.filename);
			)
		)
		return _maps.getIndex map;
	),
		
	function writeXColor color = (
		r = color.r as string + ",";
		r = r + color.g as string + ",";
		r = r + color.b as string;
		return r;
	),
	
	function writeMaterial mat source = (
		
		if _materials.get mat != undefined then (
			if classof source == shell_material then mat = copy mat;
			if classof source == blend then mat = copy mat;
		)
		
		if _materials.get mat == undefined then (
			
			lmap = undefined;
			if classof source == shell_material then (
				if classof source.bakedMaterial == standardMaterial then lmap = source.bakedMaterial;
			)
			else if classof source == blend then (
				if classof source.map2 == standardMaterial then lmap = source.map2;
			)
			
			if classof mat != standardMaterial then (
				mat = standard();
				mat.diffuse = color 150 150 150;
			);
			
			x = _materials.add mat (xchunk "material");
			x.addAttribute "id" (_materials.getIndex mat);
			x.addAttribute "name" mat.name;
			x.addAttribute "twoSided" mat.twoSided;
			x.addAttribute "opacity" mat.opacity;
			
			-- SELF ILLUMINATION
			try
			(
			if mat.selfIllumMapEnable == true and mat.selfIllumMap != undefined then (
				self = x.addNode (xchunk "selfIllumination");
				self.addAttribute "map" (writeMap mat.selfIllumMap);
				self.addAttribute "level" mat.selfIllumMapAmount;
			)
			else (
				if mat.useSelfIllumColor == true then (
					self = x.addNode (xchunk "selfIllumination");
					self.addAttribute "color" (writeXColor mat.selfIllumColor);
				) else if mat.selfIllumAmount > 0 then (
					self = x.addNode (xchunk "selfIllumination");
					self.addAttribute "level" mat.selfIllumAmount;
				)
			)
			
			-- DIFFUSE
			
			diffuse = xchunk "diffuse";
			diffuse.addAttribute "color" (writeXColor mat.diffuse);
			if mat.diffuseMapEnable == true and mat.diffusemap != undefined then (
				diffuse.addAttribute "map" (writeMap mat.diffusemap);
				diffuse.addAttribute "level" mat.diffuseMapAmount;
			)
			x.addNode diffuse;
			
			-- SPECULAR
			
			specular = xchunk "specular";
			if mat.specularLevelMapEnable == true and mat.specularLevelMap != undefined then (
				specular.addAttribute "map" (writeMap mat.specularLevelMap);
				specular.addAttribute "level" mat.specularLevelMapAmount;
			)
			else if mat.specularMapEnable == true and mat.specularMap != undefined then (
				specular.addAttribute "map" (writeMap mat.specularMap);
				specular.addAttribute "level" mat.specularMapAmount;
			)
			else (
				specular.addAttribute "color" (writeXColor mat.specular);
				specular.addAttribute "level" mat.specularLevel;
			)
			specular.addAttribute "glossiness" mat.glossiness;
			x.addNode specular;
			
			-- OPACITY
			
			if mat.opacityMapEnable == true and mat.opacityMap != undefined then (
				opacity = xchunk "opacity";
				opacity.addAttribute "map" (writeMap mat.opacityMap);
				opacity.addAttribute "level" mat.opacityMapAmount;
				if classof mat.opacityMap == bitmapTexture then (
					if mat.opacityMap.monoOutput == 1 then opacity.addAttribute "mask" "true";
				)
				x.addNode opacity;
			)
			
			-- BUMP
			
			if mat.bumpMapEnable == true and mat.bumpMap != undefined then (
				bump = xchunk "bump";
				bump.addAttribute "map" (writeMap mat.bumpMap);
				bump.addAttribute "level" mat.bumpMapAmount;
				x.addNode bump;
			)
			
			-- REFLECTION
			
			if mat.reflectionMapEnable == true and mat.reflectionMap != undefined then (
				refl = xchunk "reflection";
				refl.addAttribute "map" (writeMap mat.reflectionMap);
				refl.addAttribute "level" mat.reflectionMapAmount;
				x.addNode refl;
			)
			
			-- REFRACTION
			
			if mat.refractionMapEnable == true and mat.refractionMap != undefined then (
				refr = xchunk "refraction";
				refr.addAttribute "map" (writeMap mat.refractionMap);
				refr.addAttribute "level" mat.refractionMapAmount;
				refr.addAttribute "ior" mat.ior;
				x.addNode refr;
			)
			
			-- DISPLACEMENT
			
			if mat.displacementMapEnable == true and mat.displacementMap != undefined then (
				disp = xchunk "displacement";
				disp.addAttribute "map" (writeMap mat.displacementMap);
				disp.addAttribute "level" mat.displacementMapAmount;
				x.addNode disp;
			)
			
			-- LIGHT MAP
			if lmap != undefined then (
				lm = xchunk "lightmap";
				lm.addAttribute "map" (writeMap lmap.diffusemap);
				lm.addAttribute "level" lmap.diffuseMapAmount;
				x.addNode lm;
			) else if mat.ambientMapEnable == true and mat.ambientMap != undefined then (
				lm = xchunk "lightmap";
				lm.addAttribute "map" (writeMap mat.ambientMap );
				lm.addAttribute "level" mat.ambientMapAmount;
				x.addNode lm;
			) else if mat.filterMapEnable == true and mat.filterMap != undefined then (
				lm = xchunk "lightmap";
				lm.addAttribute "map" (writeMap mat.filterMap );
				lm.addAttribute "level" mat.filterMapAmount;
				x.addNode lm;
			)
			
		) catch ()
		)
		
		return _materials.getIndex mat;
	),
	
	function getMatRef obj = (
		if classof obj.material == standard then return obj.material;
		if classof obj.material == multimaterial then return obj.material;
		if classof obj.material == shell_material then return obj.material.originalMaterial;
		if classof obj.material == blend then return obj.material.map1;
		return undefined;
	),
	
	function writeMesh node xNode = (
		
		-- gets the max number of surfaces for this mesh.
		local references = getInstances node;
		local maxMatCount = 1;
		for n in references where classof (getMatRef n) == multimaterial and (getMatRef n).count > maxMatCount do maxMatCount = (getMatRef n).count;
		
		if _instances.get node == undefined then (
			local mesh = snapshotasmesh node;
			local inv4 = inverse node.transform;
			local inv3 = copy inv4; inv3.translation = point3 0 0 0;
			local surfaces = #();			
			local supports = "POSITION,NORMAL";
			local formats = "float3,float3"
			local uvCount = 0;
			
			useUV0 = undefined;
			useUV1 = undefined;
			useUV2 = undefined;
			useUV3 = undefined;
			useCOLOR0 = undefined;
			useCOLOR1 = undefined;
			useCOLOR2 = undefined;
			
			size = 6;
			count = 0;
			for channel = 1 to meshOp.getNumMaps mesh do (
				if meshOp.getMapSupport mesh channel == true then (
					supports += (",UV" + (channel - 1) as string);
					formats += ",float2";
						 if channel == 1 then ( useUV0 = channel; size += 2 )
					else if channel == 2 then ( useUV1 = channel; size += 2 )
					else if channel == 3 then ( useUV2 = channel; size += 2 )
					else if channel == 4 then ( useUV3 = channel; size += 2 )
				)
			)
			for channel = 0 to -2 by -1 do (
				if meshOp.getmapsupport mesh channel == true then (
					supports += (",COLOR" + (-channel) as string)
					formats += ",float3";
					if channel == 0 then ( useCOLOR0 = channel; size += 3 )
					if channel == -1 then ( useCOLOR1 = channel; size += 3 )
					if channel == -2 then ( useCOLOR2 = channel; size += 3 )
				)
			)
			
			surfaces = for i = 1 to maxMatCount collect surf node i surfID;
			
			for i = 1 to mesh.numFaces do 
			(
				local face = getface mesh i;				
				local matID = mod (getFaceMatID mesh i - 1) maxMatCount + 1;
				local normal = meshop.getFaceRNormals mesh i;
				local pos0 = getvert mesh face.x * inv4; normal[1] *= inv3
				local pos1 = getvert mesh face.y * inv4; normal[2] *= inv3
				local pos2 = getvert mesh face.z * inv4; normal[3] *= inv3
				
				local tFace
				if useUV0 != undefined then (
					tFace = meshOp.getMapFace mesh 1 i;
					local uv0a = meshop.getMapVert mesh 1 tFace.x;
					local uv0b = meshop.getMapVert mesh 1 tFace.y;
					local uv0c = meshop.getMapVert mesh 1 tFace.z;
				)
				if useUV1 != undefined then (
					tFace = meshOp.getMapFace mesh 2 i;
					local uv1a = meshop.getMapVert mesh 2 tFace.x;
					local uv1b = meshop.getMapVert mesh 2 tFace.y;
					local uv1c = meshop.getMapVert mesh 2 tFace.z;
				)
				if useUV2 != undefined then (
					tFace = meshOp.getMapFace mesh 3 i;
					local uv2a = meshop.getMapVert mesh 3 tFace.x;
					local uv2b = meshop.getMapVert mesh 3 tFace.y;
					local uv2c = meshop.getMapVert mesh 3 tFace.z;
				)
				if useUV3 != undefined then (
					tFace = meshOp.getMapFace mesh 4 i;
					local uv3a = meshop.getMapVert mesh 4 tFace.x;
					local uv3b = meshop.getMapVert mesh 4 tFace.y;
					local uv3c = meshop.getMapVert mesh 4 tFace.z;
				)
				if useCOLOR0 != undefined then (
					tFace = meshOp.getMapFace mesh useCOLOR0 i;
					local color0a = meshop.getMapVert mesh useCOLOR0 tFace.x;
					local color0b = meshop.getMapVert mesh useCOLOR0 tFace.y;
					local color0c = meshop.getMapVert mesh useCOLOR0 tFace.z;
				)
				if useCOLOR1 != undefined then (
					tFace = meshOp.getMapFace mesh useCOLOR1 i;
					local color1a = meshop.getMapVert mesh useCOLOR1 tFace.x;
					local color1b = meshop.getMapVert mesh useCOLOR1 tFace.y;
					local color1c = meshop.getMapVert mesh useCOLOR1 tFace.z;
				)
				if useCOLOR2 != undefined then (
					tFace = meshOp.getMapFace mesh useCOLOR2 i;
					local color2a = meshop.getMapVert mesh useCOLOR2 tFace.x;
					local color2b = meshop.getMapVert mesh useCOLOR2 tFace.y;
					local color2c = meshop.getMapVert mesh useCOLOR2 tFace.z;
				)
				
				local surf = surfaces[matID];
				
				s = surf.vertex;
				
				writefloat s pos2.x; writefloat s pos2.z; writefloat s pos2.y;
				writefloat s normal[3].x; writefloat s normal[3].z; writefloat s normal[3].y;				
				if useUV0 != undefined then ( writefloat s uv0c.x; writefloat s (1 - uv0c.y) );
				if useUV1 != undefined then ( writefloat s uv1c.x; writefloat s (1 - uv1c.y) );
				if useUV2 != undefined then ( writefloat s uv2c.x; writefloat s (1 - uv2c.y) );
				if useUV3 != undefined then ( writefloat s uv3c.x; writefloat s (1 - uv3c.y) );
				if useCOLOR0 != undefined then ( writefloat s color0c.x; writefloat s color0c.y; writefloat s color0c.z );
				if useCOLOR1 != undefined then ( writefloat s color1c.x; writefloat s color1c.y; writefloat s color1c.z );
				if useCOLOR2 != undefined then ( writefloat s color2c.x; writefloat s color2c.y; writefloat s color2c.z );
				
				writefloat s pos1.x; writefloat s pos1.z; writefloat s pos1.y;
				writefloat s normal[2].x; writefloat s normal[2].z; writefloat s normal[2].y;				
				if useUV0 != undefined then ( writefloat s uv0b.x; writefloat s (1 - uv0b.y) );
				if useUV1 != undefined then ( writefloat s uv1b.x; writefloat s (1 - uv1b.y) );
				if useUV2 != undefined then ( writefloat s uv2b.x; writefloat s (1 - uv2b.y) );
				if useUV3 != undefined then ( writefloat s uv3b.x; writefloat s (1 - uv3b.y) );
				if useCOLOR0 != undefined then ( writefloat s color0b.x; writefloat s color0b.y; writefloat s color0b.z );
				if useCOLOR1 != undefined then ( writefloat s color1b.x; writefloat s color1b.y; writefloat s color1b.z );
				if useCOLOR2 != undefined then ( writefloat s color2b.x; writefloat s color2b.y; writefloat s color2b.z );
				
				writefloat s pos0.x; writefloat s pos0.z; writefloat s pos0.y;
				writefloat s normal[1].x; writefloat s normal[1].z; writefloat s normal[1].y;				
				if useUV0 != undefined then ( writefloat s uv0a.x; writefloat s (1 - uv0a.y) );
				if useUV1 != undefined then ( writefloat s uv1a.x; writefloat s (1 - uv1a.y) );
				if useUV2 != undefined then ( writefloat s uv2a.x; writefloat s (1 - uv2a.y) );
				if useUV3 != undefined then ( writefloat s uv3a.x; writefloat s (1 - uv3a.y) );
				if useCOLOR0 != undefined then ( writefloat s color0a.x; writefloat s color0a.y; writefloat s color0a.z );
				if useCOLOR1 != undefined then ( writefloat s color1a.x; writefloat s color1a.y; writefloat s color1a.z );
				if useCOLOR2 != undefined then ( writefloat s color2a.x; writefloat s color2a.y; writefloat s color2a.z );
			)
			
			for surf in surfaces do (
				if ftell surf.vertex > 0 then (
					x = _surfaces.add surf (xchunk "surface");
					x.addAttribute "id" (_surfaces.getIndex surf as string);
					x.addAttribute "source" surf.filename;
					x.addAttribute "sizePerVertex" size;
					x.addAttribute "inputs" supports;
					x.addAttribute "formats" formats;
				)
				surf.close();
			)
			for n in references do _instances.add n surfaces;
		) 
		
		surfIDs = "";
		matsIDs = "";
		for surf in _instances.get node where surf.vertex != undefined do (
			
			local material = getMatRef node;
			if classof material == multimaterial then material = material[mod (surf.matID - 1) material.count + 1];
			if classof material == shell_material then ();
			else if classof material == Blend then ();
			else if classof material == compositeMaterial then ();
			else if classof material != standardMaterial then (
				material = standard();
				material.diffuse = node.wirecolor;
			)
			surfIDs += (_surfaces.getIndex  surf) as string + ",";
			matsIDs += (writeMaterial material node.material) as string + ",";
		)
		
		xNode.addAttribute "surfaces" (substring surfIDs 1 (surfIDs.count - 1));
		xNode.addAttribute "materials" (substring matsIDs 1 (matsIDs.count - 1));
		
		writeBounds node xNode;
	),
	
	function writeUserData node modifier = (
		
		if _modifiers.get modifier == undefined then (
			
			xNode = _modifiers.add modifier (xchunk "modifier");
			xNode.addAttribute "id" (_modifiers.values.count - 1);
			xNode.addAttribute "type" "userData";
			
			for i = 1 to modifier.variables.count do (				
				x = xNode.addNode (xchunk "data");
				x.addAttribute "name" modifier.variables[i];
				x.addAttribute "value" modifier.values[i];
				x.addAttribute "type" ( tolower modifier.types[i] )	
			)
		)
		
		return _modifiers.getIndex modifier;
	),
	
	function writeLabels node modifier = (
		
		if _modifiers.get modifier == undefined then (
			
			xNode = _modifiers.add modifier (xchunk "modifier");
			xNode.addAttribute "id" (_modifiers.values.count - 1);
			xNode.addAttribute "type" "labels";
			
			for i = 1 to modifier.labels.count do (
				x = xNode.addNode (xchunk "label");
				x.addAttribute "name" modifier.labels[i];
				x.addAttribute "from" modifier.lfrom[i];
				x.addAttribute "to" modifier.lto[i];
			)
		)
		
		return _modifiers.getIndex modifier;
	),
	
	function writeSkin node skin = (
		
		if _modifiers.get skin == undefined then (
			
			skin.weightAllVertices = true;
			
			local arr = objects as array
			for i = 1 to arr.count do arr[i].name = ( i as string ) + "_" + arr[i].name
			
			id = _modifiers.values.count;
			
			target = finditem (objects as array) node - 1;
			
			filename = (superFileName + "_" + id as string);
			
			xNode = _modifiers.add skin (xchunk "modifier");
			xNode.addAttribute "id" id;
			xNode.addAttribute "type" "skin";
			xNode.addAttribute "target" target;
			xNode.addAttribute "bonesPerVertex" totalBones;
			
			max modify mode; select node; modPanel.setCurrentObject skin;
			
			-- BONES
			
-- 			skinOps.RemoveZeroWeights skin;
			
			local mesh = snapshotasmesh node;
			local boneCount = skinOps.GetNumberBones skin;
			local vertexCount = skinOps.GetNumberVertices skin;			
			
			function getBoneIndex arr name = (
				for i = 1 to arr.count do (
					if arr[i].name == name then return finditem arr arr[i] - 1 
				)
			)
			
			strBones = "";
-- 			for i = 1 to boneCount do strBones += ( getBoneIndex arr ( skinOps.GetBoneName skin i 0 ) as string + "," ) ;			
-- 			for i = 1 to boneCount do (
-- 				print (i as string + " " + skinOps.GetBoneName skin i 1)
-- 				strBones += ( getBoneIndex arr ( skinOps.GetBoneName skin i 1) as string + "," ) ;
-- 			)
			
			-- versions prior to max 2014 get the bones sorted by names.
			local sorted = #()			
			for i = 1 to boneCount do	append sorted (skinOps.GetBoneName skin i 0)
			sort sorted			
			for i = 1 to boneCount do (
				strBones += ( getBoneIndex arr sorted[i] as string + "," ) ;
			)			
			
			strBones = substring strBones 1 (strBones.count - 1);
			xNode.addAttribute "bones" strBones;
			
			-- WEIGHTS AND ID's
			
			-- gets the max number of surfaces for this mesh.
			local references = getInstances node;
			local maxMatCount = 1;
			for n in references where classof (getMatRef n) == multimaterial and (getMatRef n).count > maxMatCount do maxMatCount = (getMatRef n).count;
			
			local supports = "SKIN_WEIGHTS,SKIN_INDICES";
			local formats = "float" + totalBones as string + ",float" + totalBones as string;
			local surfaces = for i = 1 to maxMatCount collect surf node i surfID (totalBones * 2);
			
			function getVertexList skin vert = (
				
				struct wtable ( weight, id; )
				
				function compare v0 v1 = (
						 if v0.weight > v1.weight then return -1;
					else if v0.weight < v1.weight then return 1;
					else return 0;
				)
				
				list = #();
				count = skinOps.getVertexWeightCount skin vert;
				for v = 1 to count do (
					weight = skinOps.getVertexWeight skin vert v;
					boneID = (skinOps.getVertexWeightBoneId skin vert v - 1) * 3;
					append list (wtable weight boneID);
				)
				qsort list compare;
				if count < 1 then list = #((wtable 1 0));
				if list[1].weight == 0 then list[1].weight = 1;
				while list.count < totalBones do list = append list (wtable 0 0);
				list.count = totalBones;
				
				-- normalize.
				sum = 0;
				for v = 1 to totalBones do sum += list[v].weight;
				for v = 1 to totalBones do list[v].weight = list[v].weight / sum;
				return list;
			)
			
			for i = 1 to mesh.numFaces do (
				local face = getface mesh i;
				local matID = mod (getFaceMatID mesh i - 1) maxMatCount + 1;
				local surf = surfaces[matID].vertex;				
				l0 = getVertexList skin face.x;
				l1 = getVertexList skin face.y;
				l2 = getVertexList skin face.z;				
				for v = 1 to totalBones do writeFloat surf l2[v].weight;
				for v = 1 to totalBones do writeFloat surf l2[v].id;
				for v = 1 to totalBones do writeFloat surf l1[v].weight;
				for v = 1 to totalBones do writeFloat surf l1[v].id;
				for v = 1 to totalBones do writeFloat surf l0[v].weight;
				for v = 1 to totalBones do writeFloat surf l0[v].id;
			)
			
			for surf in surfaces do (
				if ftell surf.vertex > 0 then (
					x = _surfaces.add surf (xchunk "surface");
					x.addAttribute "id" (_surfaces.getIndex surf as string);
					x.addAttribute "name" surf.filename;
					x.addAttribute "sizePerVertex" surf.sizePerVertex;
					x.addAttribute "inputs" supports;
					x.addAttribute "formats" formats;
					x.addAttribute "source" surf.filename;
				)
				surf.close();
			)
			
			surfIDs = "";
			for surf in surfaces where surf.vertex != undefined do surfIDs += (_surfaces.getIndex surf) as string + ",";
			xNode.addAttribute "surfaces" (substring surfIDs 1 (surfIDs.count - 1));
			
			-- change back to original names.
			local c = 0; for b in arr do ( c+=1; arr[c].name = substring arr[c].name ((c as string).count + 2) -1 )
		)
		
		return _modifiers.getIndex skin;
	),
	
	function writeLight node xNode = (
		
		local type = "point";
		
		try (
		if classof node == skylight then type = "ambient";
		else if classof node == targetobject then type = "";
		else if node.type == #targetSpot then type = "directional";
		else if node.type == #freespot then type = "directional";	
		else if node.type == #targetDirect then type = "directional";
		else if node.type == #freeDirect then type = "directional";
		else if node.type == #Target_Point then type = "directional";
		
		xNode.addAttribute "class" type;
		xNode.addAttribute "enabled" node.enabled;
		if type != "" then (
			xNode.addAttribute "color" (writeXColor node.rgb);
			xNode.addAttribute "multiplier" node.multiplier;
			if type != "ambient" then (
				xNode.addAttribute "useNearAtten" node.useNearAtten;
				xNode.addAttribute "nearAttenStart" node.nearAttenStart;
				xNode.addAttribute "nearAttenEnd" node.nearAttenEnd;
				xNode.addAttribute "useFarAtten" node.useFarAtten;
				xNode.addAttribute "farAttenStart" node.farAttenStart;
				xNode.addAttribute "farAttenEnd" node.farAttenEnd;
			)
		)
		)catch ()
	),
	
	function writeCamera node xNode = (
		
		xNode.addAttribute "class" ( tolower ( ( classof node ) as string ) )
		xNode.addAttribute "fov" node.fov;
		if node.clipManually == true then (
			xNode.addAttribute "nearclip" node.nearclip;
			xNode.addAttribute "farclip" node.farclip;
		) else (
			xNode.addAttribute "nearclip" 0.1;
			xNode.addAttribute "farclip" 10000;
		)
		if activeCamera == undefined or activeCamera == node then (
			xNode.addAttribute "active" true;
			activeCamera = node;
		) else (
			xNode.addAttribute "active" false;
		)
	),
	
	function writeHelper node xNode = (		
		xNode.addAttribute "class" ( tolower ( ( classof node ) as string ) );		
	),
	
	function writeSpline node index = (
		
		local knots = numKnots node index;
		local closed = false; if ( numSegments node index ) == knots then closed = true;
		
		inv = inverse node.transform;
		
		x = xchunk "spline"; append _splines x;
		x.addAttribute "id" (_splines.count - 1);
		x.addAttribute "closed" closed;
		
		local stream = "";
		for k = 1 to knots do (
			local vertex = ( getKnotPoint node index k ) * inv;
			local vIn = ( getInVec node index k ) * inv;
			local vOut = ( getOutVec node index k ) * inv;
			stream += vertex.x as string + ",";
			stream += vertex.z as string + ",";
			stream += vertex.y as string + ",";
			stream += vin.x as string + ",";
			stream += vin.z as string + ",";
			stream += vin.y as string + ",";
			stream += vout.x as string + ",";
			stream += vout.z as string + ",";
			stream += vout.y as string + ",";
		)
		x.addAttribute "stream" (substring stream 1 (stream.count - 1));
			
		return (_splines.count - 1);
	),
	
	function writeShape shape xNode = (
		local node = copy shape
		convertToSplineShape node
		local splines = "";
		for index = 1 to numSplines node do (
			splines += (writeSpline node index) as string + ",";
		)
		xnode.addAttribute "color" (writeXColor shape.wirecolor);
		xnode.addAttribute "splines" (substring splines 1 (splines.count - 1));
		delete node
	),
	
	function writeObject node = (
		
		local type = "pivot";
			 if classof node == targetobject then type = "pivot";
		else if superclassof node == Helper then type = "helper";
		else if superclassof node == Camera then type = "camera";
		else if superclassof node == Light then type = "light";
		else if superclassof node == Shape then type = "shape";
		else if superclassof node == GeometryClass then type = "mesh";
		
		if onlyAnimations == true then type = "joint";
		
		-- transform to local space.
		local transform = node.transform; 
		if node.parent != undefined then transform *= ( inverse node.parent.transform );
		
		if exportHidden == false and node.isHiddenInVpt == true then type = "pivot";
		
		x = xchunk "node";
		x.addAttribute "id" nodeID; nodeID += 1;
		x.addAttribute "name" node.name;
		x.addAttribute "type" type;
		
		if exportHidden == true then (
			if exportAsInvisible == true then (
				if node.isHiddenInVpt == true then x.addAttribute "visible" "false" else x.addAttribute "visible" "true"
			) else (
				x.addAttribute "visible" "true";
			)
		)
		
		local mRender = node.modifiers["F3DRender"];
		if mRender != undefined then x.addAttribute "layer" mRender.priority;
		
		if onlyAnimations == false then 
		(
			if type == "mesh" then writeMesh node x;
			if type == "light" then writeLight node x;
			if type == "camera" then writeCamera node x;
			if type == "helper" then writeHelper node x;
			if type == "shape" then writeShape node x;
		)
		
		x.addAttribute "transform" (writeMatrix3D transform node);
		
		if exportAnimations == true then (
			animID = writeAnimation node x;
			if animID != -1 then x.addAttribute "animation" animID;
		)
		
		local modifiers = "";
		for modifier in node.modifiers do (
			if classof modifier == F3DAnimation then modifiers += ((writeLabels node modifier) as string + ",");
			if classof modifier == f3dUserdata and onlyAnimations == false then  modifiers += ((writeUserData node modifier) as string + ",");
		)
		if modifiers != "" then x.addAttribute "modifiers" (substring modifiers 1 (modifiers.count - 1));
		
		for child in node.children do x.addNode (writeObject child);
		
		if node.parent == undefined do append _nodes x;
			
		return x;
	),
	
	function writeViewport = (
		
		if onlyAnimations == true then return false
		if viewport.isperspview() == false then return false
		
		at time animationRangeStart (
			cam = freecamera()
			cam.name = "Viewport Camera"
			cam.fov = viewport.getFOV()
			cam.nearclip = 0.1
			cam.farclip = 10000
			cam.transform = inverse ( getViewTM() )
			if viewport.getCamera() == undefined then viewport.setcamera cam			
			activeCamera = cam
			writeObject cam
			delete cam
		)
	),
	
	function create path file = (
		
		superPath = path;
		
		nodeID = 0;
		surfID = 0;
		
		max select none;
		with redraw off;
		
		makeDir path all:true;
		for f in getFiles (path + "/*.*") do deleteFile f;

		stream = createFile (path + "main.xml");
-- 		stream = stringstream ""
		
		format "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n" to:stream
		
		root = xChunk "f3d";
		root.addAttribute "version" "1";
		
		if viewport.isperspview() == true then (
			activeCamera = viewport.getCamera()
			if activeCamera == undefined then activeCamera = 1
		)
		
		for node in objects do if node.parent == undefined do writeObject node;
		
		-- viewport / active camera.
		if exportViewportCamera == true then (
			if activeCamera == 1 then writeViewport();
			if activeCamera == undefined then (
				local active = viewport.activeViewport;
				for i = 1 to viewport.numViews do (
					viewport.activeViewport = i
					if viewport.isperspview() == true and activeCamera == undefined then writeViewport()
				)			
				viewport.activeViewport = active
			)
		)
-- 		if activeCamera == undefined and onlyAnimations == false then messagebox "No camera found!" title:"Flare3D Exporter"
		
		at time animationRangeStart (
			x = xchunk "nodes";
			for node in _nodes do x.addNode node;
			root.addNode x;
		)
		
		if onlyAnimations == false then (
			for node in objects do (
				for modifier in node.modifiers do (
					if classof modifier == skin and (exportHidden == true or node.isHiddenInVpt == false) then writeSkin node modifier;
				)
			)
		)
		
		if _materials.values.count > 0 then (
			x = xchunk "materials";
			for mat in _materials.values do x.addNode mat;
			root.addNodeAt x 0;
		)
		
		if _maps.values.count > 0 then (
			x = xchunk "maps";
			for map in _maps.values do x.addNode map;
			root.addNodeAt x 0;
		)
		
		if _splines.count > 0 then (
			x = xchunk "splines";
			for spline in _splines do x.addNode spline;
			root.addNodeAt x 0;
		)
		
		if _surfaces.values.count > 0 then (
			x = xchunk "surfaces";
			for surf in _surfaces.values do x.addNode surf;
			root.addNodeAt x 0;
		)
		
		if _modifiers.values.count > 0 then (
			x = xchunk "modifiers";
			for modifier in _modifiers.values do x.addNode modifier;
			root.addNodeAt x 0;
		)
		
		if _animations.values.count > 0 then (
			x = xchunk "animations";
			for anim in _animations.values do x.addNode anim;
			root.addNodeAt x 0;
		)
		
		root.write stream;
	),
	
	function close = (		
		::close stream;
		stream as string
	)
)

rollout lightMapsOptions "Light Maps Options" width:250 (
	group " Texture Options: " (
		spinner quality "Quality: " type:#integer range:[1,100,100] fieldwidth:40 across:2;
		spinner minBakeSize "Min Size: " type:#integer range:[16,2048,32] fieldwidth:40;
		spinner maxBakeSize "Max Size: " type:#integer range:[16,2048,512] fieldwidth:40;
	)
	group " Output Folder: " (
		button path "..." width:220 align:#right;
	)
	button ok "Accept" across:2 offset:[25,10];
	button cancel "Cancel" offset:[-25,10];
	
	function getPath = (
		result = getINISetting flare3d_ini_file "lightmaps" "path";
		if result == "" then result = getdir #temp;
		return result;
	)
	on path pressed do (
		result = getSavePath caption:"Select Light Maps Output Folder" initialDir:(path.caption);
		if result != undefined then (
			path.caption = result;
			path.tooltip = result;
		)
	)
	on ok pressed do (
		setINISetting flare3d_ini_file "lightmaps" "path" path.tooltip;
		setINISetting flare3d_ini_file "lightmaps" "min" (minBakeSize.value as string);
		setINISetting flare3d_ini_file "lightmaps" "max" (maxBakeSize.value as string);
		setINISetting flare3d_ini_file "lightmaps" "quality" (quality.value as string);
		destroydialog lightMapsOptions;
	)
	on cancel pressed do (
		destroydialog lightMapsOptions;
	)
	on lightMapsOptions open do (
		path.caption = getPath();
		path.tooltip = path.caption;
		if path.caption == "" then path.caption = "...";
		
		minBakeSize.value 	= getINIValue "lightmaps" "min" 32 as integer;
		maxBakeSize.value 	= getINIValue "lightmaps" "max" 1024 as integer;
		quality.value 		= getINIValue "lightmaps" "quality" 100 as integer;
	)
)

rollout f3d_rollout ("Flare3D " + f3d_plugin_version) width:180 (
-- 	group "Export:" (
		dropdownlist fileFormat items:#("Open File (zf3d)", "Binary File (f3d)") visible:false offset:[0,-24]
-- 	)
	group "General:" (
		checkbox embed "Embed Resources" checked:true enabled:false visible:false --offset:[0,-40];
		checkbox hidden "Export Hidden Objects" checked:true offset:[0, -20]
		checkbox invisible "Export Hidden as Invisible" checked:true offset:[0, 0]
		checkbox viewCam "Export Viewport Camera" checked:true;
	)
	group "Animations:" (
		checkbox onlyAnims "Only Animations" checked:false;
		checkbox anims "Export Animations" checked:true;
		--spinner skip "Skip Frames: " type:#integer range:[1,100,1] fieldwidth:30 align:#left;
		spinner rFrom "From: " type:#integer range:[animationRange.start,animationRange.end,animationRange.start] fieldwidth:30 align:#left across:2;
		spinner rTo "To: " type:#integer range:[animationRange.start,animationRange.end,animationRange.end] fieldwidth:30 align:#left;
	)
	group "Convert Unsupported Textures:" (
		radiobuttons textures labels:#("jpg", "png") across:2; --*"jxr"
		spinner quality "Quality: " type:#integer range:[1,100,80] --fieldwidth:20 align:#left;
	)
	
	group "Light Maps:" (
		radiobuttons bake labels:#("None", "Bake All", "Only Selected") offset:[10,0] across:2;
		button lightMapsPlus "..." width:25 height:25 offset:[10,5] tooptip:"Light Maps Options";
	)
	
	button export "Export" height:30 width:70 across:2;
	button preview "Preview" height:30 width:70;
	
	function update = (
		if fileFormat.selection == 1 then (
			embed.enabled = false;
			export.enabled = true;
			preview.enabled = true;
		)
		else if fileFormat.selection == 2 then (
			embed.enabled = true;
			export.enabled = false;
			preview.enabled = false;
		)
-- 		skip.enabled = false;
		if textures.state == 1 then quality.enabled = true else quality.enabled = false;
		
		if onlyAnims.checked == true then (
			anims.checked = true;
			anims.enabled = false;
		)
		else anims.enabled = true;
		
		if hidden.checked == true then (
			invisible.enabled = true;
		) else (
			invisible.enabled = false;
			invisible.checked = false;
		)
	)
	
	on lightMapsPlus pressed do (
		createdialog lightMapsOptions modal:true;
	)
	on fileFormat selected val do (
		update();
	)
	on onlyAnims changed val do (
		update();
	)
	on anims changed val do (
		update();
	)

-- 	on skip changed val do (
-- 		setINISetting flare3d_ini_file "exporter" "skip" ( skip.value as string );
-- 		update();
-- 	)
	on textures changed val do (
		update();
	)
	on quality changed val do (
		update();
	)
	on embed changed val do (
		update();
	)
	on hidden changed val do (
		update();
	)	
	on invisible changed val do (
		update();
	)
	
	function goForIt file param = (
	 	local path = ( getdir #temp ) + "/Flare3D 2.5/preview"
	 	local tools = ( getdir #startupScripts ) + "/Flare3D 2.5/"
		
		tMinSize = getINIValue "lightmaps" "min" 32 as integer;
		tMaxSize = getINIValue "lightmaps" "max" 1024 as integer;
		tQuality = getINIValue "lightmaps" "quality" 100 as integer;
		tPath = getINIValue "lightmaps" "path" (getDir #temp);
		
		f3d_arr_selection = selection as array;
		
		if onlyAnims.checked == false then (
			if bake.state == 2 then (
				lm = f3d_lightmaps nodes:(objects as array) quality:tQuality minSize:tMinSize maxSize:tMaxSize path:tPath;
			) else if bake.state == 3 then (
				lm = f3d_lightmaps nodes:f3d_arr_selection quality:tQuality minSize:tMinSize maxSize:tMaxSize path:tPath;
			)
		)
		
		surfID = 0;
		animationRangeStart = rFrom.value -- animationRange.start;
		animationRangeEnd = rTo.value -- animationRange.end;
		skipFrames = 1;
		
	 	f = f3d_exporter();
		f.exportHidden = hidden.checked;
		f.exportAsInvisible = invisible.checked;
		f.exportViewportCamera = viewCam.checked;
		f.exportAnimations = anims.checked;
		f.onlyAnimations = onlyAnims.checked;
		f.textureMode = textures.state;
		f.textureQuality = quality.value;
	 	f.create (path + "/") "main.xml";
	 	f.close();

		select f3d_arr_selection;
		
		fn existFile fname = (getfiles fname).count != 0;
		if (existFile file) then deletefile file;
		
		hiddenDOScommand ( "\"" + tools + "zip.exe\" -r -j \"" + file + "\" \"" + param + "\*.*" );
-- 		print ( "\"" + tools + "zip.exe\" -r -j \"" + file + "\" \"" + param + "\*.*" );

-- 	 	shelllaunch (tools + "Flare3D Tools.exe") ("-zip \"" + path + "\" -output \"" + file + "\" " + param );
	)
	
	on preview pressed do (
		
	 	local path = ( getdir #temp ) + "/Flare3D 2.5/"
	 	local tools = ( getdir #startupScripts ) + "/Flare3D 2.5/"	
		makedir path all:true;
		
		goForIt ( path + "preview.zf3d" ) (path + "preview") --"-launch";
		sleep 0.2
		shelllaunch ( path + "preview.zf3d" ) ""
		bake.state = 1;
	)
	
	on export pressed do (
		local file = f3d_saveDialog types:"Flare 3D (*.zf3d)|*.zf3d";		
		if file == undefined do return 0;
		
		local path = ( getdir #temp ) + "/Flare3D 2.5/"
		goForIt file (path + "preview");
		
		destroydialog f3d_rollout;
	)
	
	on f3d_rollout open do
	(	
		fileFormat.selection = getINISetting flare3d_ini_file "exporter" "fileFormat" as integer;		
		if getINISetting flare3d_ini_file "exporter" "hidden" == "false" then hidden.checked = false;
		if getINISetting flare3d_ini_file "exporter" "invisible" == "false" then invisible.checked = false;
		if getINISetting flare3d_ini_file "exporter" "viewCam" == "false" then viewCam.checked = false;
		if getINISetting flare3d_ini_file "exporter" "embed" == "false" then embed.checked = false;
		if getINISetting flare3d_ini_file "exporter" "onlyAnims" == "true" then onlyAnims.checked = true;
		if getINISetting flare3d_ini_file "exporter" "anims" == "false" then anims.checked = false;
-- 		skip.value = getINISetting flare3d_ini_file "exporter" "skip" as integer;		
		textures.state = getINISetting flare3d_ini_file "exporter" "textures" as integer;		
		if hasINISetting flare3d_ini_file "exporter" "quality" then
			quality.value = getINISetting flare3d_ini_file "exporter" "quality" as integer;		
		
		if fileFormat.selection == 0 then fileFormat.selection = 1;
		if textures.state == 0 then textures.state = 1;
		update();
	)
	
	on f3d_rollout close do 
	(
		setINISetting flare3d_ini_file "exporter" "fileFormat" ( fileFormat.selection as string );
		setINISetting flare3d_ini_file "exporter" "onlyAnims" ( onlyAnims.checked as string );
		setINISetting flare3d_ini_file "exporter" "anims" ( anims.checked as string );
		setINISetting flare3d_ini_file "exporter" "textures" ( textures.state as string );
		setINISetting flare3d_ini_file "exporter" "quality" ( quality.value as string );
		setINISetting flare3d_ini_file "exporter" "embed" ( embed.checked as string );
		setINISetting flare3d_ini_file "exporter" "hidden" ( hidden.checked as string );
		setINISetting flare3d_ini_file "exporter" "invisible" ( invisible.checked as string );
		setINISetting flare3d_ini_file "exporter" "viewCam" ( viewCam.checked as string );
		
		print "closed";
	)
)

function start 
	file:""
	exportAnimations:true 
	exportHidden:true
	exportAsInvisible:true
	onlyAnimations:false 
	textureMode:"jpg"
	textureQuality:100
	lightmaps:"none" -- none / all / selected
	rangeStart:animationRange.start
	rangeEnd:animationRange.end
	params:""
= (
	if file == "" then (
		clearlistener();
		createdialog f3d_rollout modal:false;
	)
	else (
		
	 	local path = ( getdir #temp ) + "/Flare3D 2.5/preview"
	 	local tools = ( getdir #startupScripts ) + "/Flare3D 2.5/"
		
		tMinSize = getINIValue "lightmaps" "min" 32 as integer;
		tMaxSize = getINIValue "lightmaps" "max" 1024 as integer;
		tQuality = getINIValue "lightmaps" "quality" 100 as integer;
		tPath = getINIValue "lightmaps" "path" (getDir #temp);
		
		f3d_arr_selection = selection as array;
		
		if onlyAnimations == false then (
			if lightmaps == "all" then (
				lm = f3d_lightmaps nodes:(objects as array) quality:tQuality minSize:tMinSize maxSize:tMaxSize path:tPath;
			) else if lightmaps == "selected" then (
				lm = f3d_lightmaps nodes:f3d_arr_selection quality:tQuality minSize:tMinSize maxSize:tMaxSize path:tPath;
			)
		)
		
		if textureMode == "jpg" then textureMode = 1;
		if textureMode == "png" then textureMode = 2;
		
		surfID = 0;
		animationRangeStart = rangeStart --animationRange.start;
		animationRangeEnd = rangeEnd --animationRange.end;
		skipFrames = 1;
		
		f = f3d_exporter();
		f.exportAnimations = exportAnimations;
		f.exportHidden = exportHidden;
		f.exportAsInvisible = exportAsInvisible;
		f.exportViewportCamera = true;
		f.onlyAnimations = onlyAnimations;
		f.textureMode = textureMode;
		f.textureQuality = textureQuality;
		f.create (path + "/") "main.xml";
		f.close();		
		select f3d_arr_selection;
		
		fn existFile fname = (getfiles fname).count != 0;
		if (existFile file) then deletefile file;
		
		hiddenDOScommand ( "\"" + tools + "zip.exe\" -r -j \"" + file + "\" \"" + path + "\*.*" );
	)
)
)

function f3d_create_menu =
(
	local flareMenu	
	local mainMenuBar = menuMan.getMainMenuBar();
	for i = 1 to mainMenuBar.numItems() do
	(
		if ((mainMenuBar.GetItem i).GetTitle()) == "Flare3D"  then
			flareMenu = (mainMenuBar.GetItem i).getSubMenu()
	)	
	
	if flareMenu != undefined do menuMan.unRegisterMenu flareMenu
	
	local flareMenu = menuMan.createMenu "Flare3D" 
	local flareMenuItem = menuMan.createSubMenuItem "Flare3D" flareMenu
	local flareMenuIndex = mainMenuBar.numItems() - 1 
	mainMenuBar.addItem flareMenuItem flareMenuIndex 
	
	local item = menuMan.createActionItem "Flare3D25Exporter" "Flare3D" 
	if item != undefined then (
		item.SetTitle "Export";
		item.SetUseCustomTitle true;
		flareMenu.addItem item -1;
	)
	
	menuMan.updateMenuBar()	
) 

f3d_create_menu();

print ("Flare3D " + f3d_plugin_version + " - Ok!");

-- f3d_plugin_v2();
-- f3d_plugin_v2 file:"c:/test.zf3d" --textureMode:"png" lightmaps:"none"