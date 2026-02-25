/// scr_ds_map_keys_array(map) -> array de keys
function scr_ds_map_keys_array(_map) {

    var _size = ds_map_size(_map);
    var _arr  = array_create(_size);

    var _key  = ds_map_find_first(_map);
    var i     = 0;

    while (_key != undefined) {
        _arr[i] = _key;
        i++;
        _key = ds_map_find_next(_map, _key);
    }

    return _arr;
}