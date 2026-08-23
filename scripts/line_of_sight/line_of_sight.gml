function line_of_sight(x1, y1, x2, y2){
    with control{
        var _x = x1, _y = y1, prev_a, prev_b, hex = xytoab(_x, _y)
        var output = array_create(1, hex)
        var total_dist = point_distance(x1, y1, x2, y2)
        if total_dist <= 0
            return output
        var n = ceil(total_dist / 13), step_x = (x2 - x1) / n, step_y = (y2 - y1) / n
        prev_a = hex[0]
        prev_b = hex[1]
        for(var i = 1; i <= n; i++){
            _x += step_x
            _y += step_y
            hex = xytoab(_x, _y)
            if hex[0] != prev_a or hex[1] != prev_b{
                array_push(output, hex)
                prev_a = hex[0]
                prev_b = hex[1]
            }
        }
        return output
    }
}