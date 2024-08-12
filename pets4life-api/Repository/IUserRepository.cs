using BusinessObject.Models;
using System;
using System.Collections.Generic;
using System.Diagnostics.Metrics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository
{
    public interface IUserRepository
    {
        Task<User> LoginMember(string email, string password);
        Task<IEnumerable<User>> GetAllMembers();
        Task<User?> GetMember(int? id);
        Task<User?> GetMemberByEmail(string email);
        Task AddMember(User member);
        Task DeleteMember(int id);
        Task UpdateMember(User member);
        Task<User> GetMemberByAppointment(int appointmentId);
    }
}
