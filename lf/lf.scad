module piece(h, x = 49, heights = [12, 24, 36]) {
    base = [[0, 0, 0], [0, x, 0], [x*sin(60), x/2, 0]];
    polyhedron(
        points=[
            for (p = base) p,
            for (i = [0 : len(base)-1]) base[i] + [0, 0, heights[h[i]-1]]
        ],
        faces=[[0, 1, 2], [1, 4, 5, 2], [2, 5, 3, 0], [0, 3, 4, 1], [3, 5, 4]]
    );
}

pieces=[
    [3, 3, 3],
    [3, 3, 2],
    [3, 3, 2],
    [3, 3, 2],
    [3, 3, 1],
    [3, 2, 2],
    [3, 2, 2],
    [3, 2, 1],
    [3, 2, 1],
    [3, 1, 2],
    [3, 1, 2],
    [3, 1, 1],
    [2, 2, 1],
    [2, 1, 1],
    [2, 1, 1],
    [1, 1, 1]
];


for (i = [0 : len(pieces) - 1]) {
    translate([(i%4)*51, floor(i / 4)*51 , 0])
    piece(pieces[i]);
}

