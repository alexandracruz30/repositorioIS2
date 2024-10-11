import math

def calcular_area_circulo(radio):
    """Calcula el área de un círculo dado su radio."""
    return math.pi * radio ** 2

if __name__ == "__main__":
    # Ejemplo de uso: calcular el área de un círculo con radio 5
    radio = 5
    area = calcular_area_circulo(radio)
    print(f"El área del círculo con radio {radio} es: {area:.2f}")
    
    #comentario 1
    #comentario 2
