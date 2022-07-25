package ecs

import "core:runtime"
import "core:container/queue"

ECS :: struct {
  
  
}

init_ecs :: proc() {
  create_entities :: proc() {
    entities.entities = make([dynamic]Entity)
    queue.init(&entities.available_slots)
  }
  create_entities()

  create_component_map :: proc() {
    component_map = make(map[typeid]Component_List)
  }

  create_component_map()
}

deinit_ecs :: proc() {

  destroy_entities :: proc() {
    delete(entities.entities)
    entities.current_entity_id = 0
    queue.destroy(&entities.available_slots)
  }
  destroy_entities()

  destroy_component_map :: proc() {
    for key, value in component_map {
      queue.destroy(&(&component_map[key]).available_slots)
      free(value.data^.data)
      free(value.data)
    }
  
    for key, value in component_map {
      delete(value.entity_indices)
    }
  
    delete(component_map)
  }
  destroy_component_map()
}

