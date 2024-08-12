import 'package:petcare/model-petcare/pet.dart';

class Appointment {
  int? appointmentId;
  int? petId;
  int? vetId;
  DateTime? appointmentDate;
  String? timeSlot;
  String? purpose;
  String? notes;
  int? serviceId;
  String? petName;

  Appointment(
      {this.appointmentId,
      this.petId,
      this.vetId,
      this.appointmentDate,
      this.timeSlot,
      this.purpose,
      this.notes,
      this.serviceId,
      this.petName});

  Appointment.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointmentId'];
    petId = json['petId'];
    vetId = json['vetId'];
    final String? dateStr = json['appointmentDate'];
    appointmentDate = dateStr != null ? DateTime.parse(dateStr) : null;
    timeSlot = json['timeSlot'];
    purpose = json['purpose'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointmentId'] = this.appointmentId;
    data['petId'] = this.petId;
    data['vetId'] = this.vetId;
    data['appointmentDate'] = this.appointmentDate;
    data['timeSlot'] = this.timeSlot;
    data['purpose'] = this.purpose;
    data['notes'] = this.notes;
    return data;
  }
}
