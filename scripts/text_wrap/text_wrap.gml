function text_wrap(str, max_width){
    var words = string_split(str, " "), result = "", line = ""
    for(var i = 0; i < array_length(words); i++){
        var test_line = (line = "" ? words[i] : line + " " + words[i])
        if string_width(test_line) > max_width{
            result += line + "\n"
            line = words[i]
        }
        else
            line = test_line
    }
    return result + line
}