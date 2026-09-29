import math
import random

BIAS = 7


def decode(s, m, e):
    """{s, m, e} -> float"""
    return (-1) ** s * (m / 128) * 2.0 ** (e - BIAS)


def encode(r):
    """float -> (s, m, e, ovf)"""
    s = 1 if r < 0 else 0       # Signo
    M, E = math.frexp(abs(r))   # Descompone en mantisa y exponente
    M, E = 2 * M, E - 1         # Por como devuelve la mantisa, hay que desplazar a la izq. 
    e = E + BIAS
    if e < 0 or e > 15:         # Overflow
        return s, 0, 0, 1       # devuelvo un overflow = true, no importa el resto asi qeu devuelvo 0
    M = math.floor(M * 128)     # truncado
    return s, M, e, 0


def rand_op():
    return random.randint(0, 1), random.randint(128, 255), random.randint(0, 15)


def fmt(s, m, e):
    return f"{{1'b{s}, 8'h{m:02X}, 4'd{e}}}"


random.seed(1)  # semilla fija (para recrear facilmente)
for _ in range(20):
    a_s, a_m, a_e = rand_op()
    b_s, b_m, b_e = rand_op()
    r = decode(a_s, a_m, a_e) * decode(b_s, b_m, b_e)
    sy, my, ey, ovf = encode(r)
    print(f"check({fmt(a_s, a_m, a_e)}, {fmt(b_s, b_m, b_e)}, {fmt(sy, my, ey)},      1'b{ovf});")