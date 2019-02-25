/**
 * Creates a TimeSlot with the given name.
 * @param {String} time - The time of the room.
 */
function TimeSlot(time) {
    this.time = time;
    this.status = "free";
    this.bookedBy = "";

    this.setStatus = function(status){
      this.status = status;
    };

    this.setBookedBy = function(bookedBy){
      this.bookedBy = bookedBy;
    };
}

module.exports = TimeSlot;