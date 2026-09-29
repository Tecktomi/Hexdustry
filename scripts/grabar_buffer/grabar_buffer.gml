function grabar_buffer(buffer){
    with control{
        var _size = buffer_tell(buffer)
        var _pos  = buffer_tell(buffer_grabacion)
        if buffer_get_size(buffer_grabacion) < _pos + _size
            buffer_resize(buffer_grabacion, _pos + _size + 1024)
        buffer_copy(buffer, 0, _size, buffer_grabacion, _pos)
        buffer_seek(buffer_grabacion, buffer_seek_relative, _size)
    }
}