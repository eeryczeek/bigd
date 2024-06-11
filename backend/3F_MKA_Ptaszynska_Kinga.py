import turtle
import random


def draw_spiral(turtle_obj, max_iter):
    for _ in range(max_iter):
        turtle_obj.speed(0)
        turtle_obj.color(random.choice(
            ['blue', 'red', 'green', 'yellow', 'purple', 'orange']))
        turtle_obj.right(random.randint(0, 360))
        length = 5
        for i in range(72):
            for _ in range(4):
                turtle_obj.forward(length)
                turtle_obj.right(90)
            length += 5
            turtle_obj.right(5)
        turtle_obj.penup()
        turtle_obj.home()
        turtle_obj.pendown()


window = turtle.Screen()
window.bgcolor('black')

turtel = turtle.Turtle()
turtel.hideturtle()

draw_spiral(turtel, 5)

turtle.done()
