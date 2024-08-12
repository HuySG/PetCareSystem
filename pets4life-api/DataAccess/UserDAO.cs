using BusinessObject.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Diagnostics.Metrics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess
{
    public class UserDAO
    {
        private static UserDAO instance = null;
        private static readonly object instanceLock = new object();

        public static UserDAO Instance
        {
            get
            {
                lock (instanceLock)
                {
                    if (instance == null)
                    {
                        instance = new UserDAO();
                    }

                    return instance;
                }
            }
        }

        public async Task<User> LoginMember(string email, string password)
        {
            var context = new Pets4lifeContext();
            var list = context.Users.ToList();
            return list.Where(member =>
                    member.Email.Equals(email, StringComparison.OrdinalIgnoreCase) && member.Password.Equals(password))
                .FirstOrDefault();
        }
        public async Task<IEnumerable<User>> GetAllMembers()
        {
            var context = new Pets4lifeContext();
            return await context.Users.ToListAsync();
        }

        public async Task<User?> GetMember(int? id)
        {
            var context = new Pets4lifeContext();
            User? member = await context.Users.Where(member => member.UserId == id).FirstOrDefaultAsync();
            return member;
        }

        public async Task<User?> GetMemberByEmail(string email)
        {
            var context = new Pets4lifeContext();
            User? member = await context.Users.Where(member => member.Email.Equals(email)).FirstOrDefaultAsync();
            return member;
        }


        public async Task AddMember(User member)
        {
            var context = new Pets4lifeContext();

            // Check if an entry with the same email already exists
            var existingUser = await context.Users.FirstOrDefaultAsync(u => u.Email == member.Email);

            if (existingUser == null)
            {
                // No user with the same email exists, so you can add the new member
                context.Users.Add(member);
                await context.SaveChangesAsync();
            }
            else
            {
                // A user with the same email already exists, handle the error or return a specific response
                throw new Exception("Email already exists."); // You can customize the exception message or use a specific exception type.
            }
        }


        public async Task DeleteMember(int id)
        {
            if ((await GetMember(id)) != null)
            {
                var context = new Pets4lifeContext();
                User member = new User() { UserId = id };
                context.Users.Attach(member);
                context.Users.Remove(member);
                await context.SaveChangesAsync();
            }
        }

        public async Task UpdateMember(User member)
        {
            var context = new Pets4lifeContext();
            context.Users.Update(member);
            await context.SaveChangesAsync();
        }

        public async Task<User> GetMemberByAppointment(int appointmentId)
        {
            var appointment = await AppointmentDAO.Instance.GetAppointment(appointmentId);
            var pets = await PetDAO.Instance.GetAllPets();

            foreach (var p in pets)
            {
                if (appointment.PetId == p.PetId)
                {
                    var user = await UserDAO.Instance.GetMember(p.UserId);
                    return user;
                }
            }
            return null;
        }
    }
}
