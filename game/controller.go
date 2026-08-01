components {
  id: "controller"
  component: "/game/game.script"
}
embedded_components {
  id: "bubble_factory"
  type: "factory"
  data: "prototype: \"/game/bubble.go\"\n"
  "load_dynamically: false\n"
}
