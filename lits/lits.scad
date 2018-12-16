x = 12;
h = 3;
slack = 0.3;

lits = [
    [
    [1, 0, 0, 0],
    [1, 0, 0, 0],
    [1, 1, 0, 0],
    [0, 0, 0, 0]
    ],
    [
    [1, 0, 0, 0],
    [1, 0, 0, 0],
    [1, 0, 0, 0],
    [1, 0, 0, 0]
    ],
    [
    [1, 1, 1, 0],
    [0, 1, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0]
    ],
    [
    [0, 1, 1, 0],
    [1, 1, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0]
    ]
];

for (n = [0 : len(lits)-1]) {
    tetromino = lits[n];
    translate([5*x*floor(n/2), 5*x*(n%2), 0])
    linear_extrude(height=h)
    offset(delta=-slack)
    projection(cut = false)
    for (i = [0 : len(tetromino)-1]) {
        row = tetromino[i];
        for (j = [0 : len(row)-1]) {
            if (row[j] == 1) {
                translate([i*x, j*x, 0])
                cube(x);
            }
        }
    }
}