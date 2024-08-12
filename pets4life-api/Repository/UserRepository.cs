using BusinessObject.Models;
using DataAccess;
using System;
using System.Collections.Generic;
using System.Diagnostics.Metrics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository
{
    public class UserRepository : IUserRepository
    {
        public Task AddMember(User member)
        {
            return UserDAO.Instance.AddMember(member);
        }

        public Task DeleteMember(int id)
        {
            return UserDAO.Instance.DeleteMember(id);
        }

        public Task<IEnumerable<User>> GetAllMembers()
        {
            return UserDAO.Instance.GetAllMembers();
        }

        public Task<User?> GetMember(int? id)
        {
            return UserDAO.Instance.GetMember(id);
        }


        public Task<User> LoginMember(string email, string password)
        {
            return UserDAO.Instance.LoginMember(email, password);
        }

        public Task UpdateMember(User member)
        {
            return UserDAO.Instance.UpdateMember(member);
        }

        public Task<User?> GetMemberByEmail(string email)
        {
            return UserDAO.Instance.GetMemberByEmail(email);
        }
        public Task<User> GetMemberByAppointment(int appointmentId)
        {
            return UserDAO.Instance.GetMemberByAppointment(appointmentId);
        }
    }
}
