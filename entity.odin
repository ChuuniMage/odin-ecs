package ecs

import "core:container/queue"

Entities :: struct {
  current_entity_id: int,

  entities: [dynamic]Entity,
  available_slots: queue.Queue(int),
}

entities: Entities

create_entity :: proc() -> Entity {
  using entities

  if queue.len(available_slots) <= 0 {
    append_elem(&entities, Entity(current_entity_id))
    current_entity_id += 1
    return Entity(current_entity_id - 1)
  } else {
    index := queue.pop_front(&available_slots)
    entities[index] = Entity(index)
    return Entity(index)
  }

  return Entity(current_entity_id)
}

destroy_entity :: proc(entity: Entity) {
  using entities

  for _, component in &component_map {
   found := entity in component.entity_indices
   if !found do continue

   queue.push_back(&component.available_slots, component.entity_indices[entity])
   delete_key(&component.entity_indices, entity)
  }

  entities[int(entity)] = {}
  queue.push_back(&available_slots, int(entity))
}