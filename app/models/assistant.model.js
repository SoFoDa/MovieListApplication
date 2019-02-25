/**
 * Creates an assistant with the given name.
 * @param {String} name - The name of the room.
 */
function Assistant(name) {
    this.name = name;
    this.timeSlots = [];    

    this.addTimeSlot = function(time){
      this.timeSlots.push(time);
    };    
}

module.exports = Assistant;