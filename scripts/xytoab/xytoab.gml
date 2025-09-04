function xytoab(x, y) {
    var b = floor(y / 14) - 1;
    var a = floor((x - 16) / 48 - ((b mod 2) / 2));
    return { a: clamp(a, 0, xsize - 1), b: clamp(b, 0, ysize - 1) };
}