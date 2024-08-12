using BusinessObject.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess
{
    public class AppointmentDAO
    {
        private static AppointmentDAO instance;
        private static object instanceLock = new object();

        public static AppointmentDAO Instance
        {
            get
            {
                lock (instanceLock)
                {
                    if (instance == null)
                    {
                        instance = new AppointmentDAO();
                    }
                    return instance;
                }
            }
        }

        public async Task<IEnumerable<Appointment>> GetAllAppointments()
        {
            var context = new Pets4lifeContext();
            return await context.Appointments.ToListAsync();
        }

        public async Task<Appointment?> GetAppointment(int id)
        {
            var context = new Pets4lifeContext();
            Appointment? member = await context.Appointments.Where(member => member.AppointmentId == id).FirstOrDefaultAsync();
            return member;
        }

        public async Task AddAppointment(Appointment member)
        {
            var context = new Pets4lifeContext();
            context.Appointments.Add(member);
            await context.SaveChangesAsync();
        }

        public async Task DeleteAppointment(int id)
        {
            if ((await GetAppointment(id)) != null)
            {
                var context = new Pets4lifeContext();
                Appointment member = new Appointment() { AppointmentId = id };
                context.Appointments.Attach(member);
                context.Appointments.Remove(member);
                await context.SaveChangesAsync();
            }
        }

        public async Task UpdateAppointment(Appointment member)
        {
            var context = new Pets4lifeContext();
            context.Appointments.Update(member);
            await context.SaveChangesAsync();
        }

        //where notes == "APPROVED"
        public async Task<IEnumerable<Appointment>> GetAppointmentsByUser(int userId)
        {
            var context = new Pets4lifeContext();
            IEnumerable<Pet> pets = await PetDAO.Instance.GetPetsByUserId(userId);
            IEnumerable<Appointment> appointments = await GetAllAppointments();

            List<Appointment> matchingAppointments = new List<Appointment>();

            foreach (var pet in pets)
            {
                var petAppointments = appointments.Where(a => a.PetId == pet.PetId);
                matchingAppointments.AddRange(petAppointments);
            }

            return matchingAppointments;
        }

        public async Task<IEnumerable<Appointment>> GetAppointmentsByPet(int petId)
        {
            var context = new Pets4lifeContext();

            var appointments = await GetAllAppointments(); // Assuming you have a method to get all appointments.

            var appointmentsForPet = appointments.Where(appointment => appointment.PetId == petId);

            return appointmentsForPet;
        }


    }
}
