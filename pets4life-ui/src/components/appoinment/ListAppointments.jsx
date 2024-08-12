import React, { useEffect, useState } from 'react';
import Header from '../Header';
import SideBar from '../Sidebar';
import { Link } from 'react-router-dom';
import ReactPaginate from 'react-paginate';
import appointmentService from '../../services/appointment.service'
import { AiFillCaretLeft, AiFillCaretRight } from "react-icons/ai"; // icons form react-icons
import { IconContext } from "react-icons"; // for customizing icons
import "../../../src/my-styles.css"

const ListAppointment = () => {

    const [appointmentList, setAppointmentList] = useState([]);
    const [msg, setMsg] = useState('');
    const [searchTerm, setSearchTerm] = useState('');
    const [currentPage, setCurrentPage] = useState(0);
    const [appointmentsPerPage] = useState(5);

    useEffect(() => {
        appointmentService
            .getAllAppointment()
            .then((res) => {
                console.log(res.data);
                setAppointmentList(res.data);

            })
            .catch((error) => {
                console.log(error);
            });
    }, []);

    const handleSearch = (event) => {
        setSearchTerm(event.target.value);
    };

    const filteredAppointments = appointmentList
        .filter((appointment) => {
            return (
                appointment.appointmentId.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                appointment.petId.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                appointment.vetId.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                appointment.timeSlot.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                appointment.purpose.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                appointment.notes.toString().toLowerCase().includes(searchTerm.toLowerCase())

            );
        });

    const pageCount = Math.ceil(filteredAppointments.length / appointmentsPerPage);

    //sort


    const handlePageClick = (data) => {
        setCurrentPage(data.selected);
    };

    const offset = currentPage * appointmentsPerPage;
    const sortedAppointments = [...filteredAppointments].sort((a, b) => b.appointmentId - a.appointmentId);

    const currentAppointments = sortedAppointments.slice(offset, offset + appointmentsPerPage);

    return (
        <>
            {/* Page Wrapper */}
            <div id="wrapper" >
            <SideBar isAdmin={sessionStorage.getItem('isAdmin') === 'true'} isStaff={sessionStorage.getItem('isStaff') === 'true'} />
                {/* Content Wrapper */}
                <div id="content-wrapper" className="d-flex flex-column" style={{ backgroundImage: `url(/banner.jpg)`, backgroundSize: 'cover', height: '100vh' }}>
                    {/* Main Content */}
                    <div id="content">
                        <Header />
                        <div className="container-fluid" >
                            {/* Page Heading */}
                            <h1 className="h3 mb-2" style={{ fontWeight: "revert", color: "#000", fontSize: "20px" }}>Appointments</h1>

                            {msg && <p className="text-center text-success">{msg}</p>}

                            {/* Search Input */}
                            <div className="mb-3">
                                <input
                                    type="text"
                                    className="form-control"
                                    placeholder="Search"
                                    value={searchTerm}
                                    onChange={handleSearch}
                                />
                            </div>
                            {/* DataTales Example */}
                            <div className="card shadow mb-4" >
                                <div className="card-body">
                                    <div className="table-responsive" >
                                        <table className="table table-hover" id="" width="100%" cellSpacing="0">
                                            <thead style={{ color: "#000" }}>
                                                <tr>
                                                    <th>Id</th>
                                                    <th>Pet</th>
                                                    <th>Vet</th>
                                                    <th>Appointment Date</th>
                                                    <th>TimeSlot</th>
                                                    <th>Purpose</th>
                                                    <th>Notes</th>

                                                </tr>
                                            </thead>
                                            <tbody>
                                                {currentAppointments.map((cus) => (
                                                    <tr key={cus.appointmentId}>
                                                        <td>{cus.appointmentId}</td>
                                                        <td>{cus.petId}</td>
                                                        <td>{cus.vetId}</td>
                                                        <td>{cus.appointmentDate}</td>
                                                        <td>{cus.timeSlot}</td>
                                                        <td>{cus.purpose}</td>
                                                        <td>{cus.notes}</td>

                                                        {cus.notes === 'PROCESSING' && (
                                                            <td>
                                                                <div className="btn-group" role="group">
                                                                    <Link to={`/edit_appointment/${cus.appointmentId}`}>
                                                                        <i class="far fa-edit text-warning"></i>                                                                  </Link>
                                                                </div>
                                                            </td>
                                                        )}

                                                        {cus.notes === 'APPROVED' && (
                                                            <td>
                                                                <div className="btn-group" role="group">
                                                                    <Link to={`/edit_appointment/${cus.appointmentId}`}>
                                                                        <i class="fa fa-check text-warning" aria-hidden="true"></i>
                                                                    </Link>
                                                                </div>
                                                            </td>
                                                        )}

                                                        {cus.notes === 'DONE' && (
                                                            <td>
                                                                <div className="btn-group" role="group">
                                                                    <i class="fa fa-check-circle text-success" aria-hidden="true"></i>
                                                                </div>
                                                            </td>
                                                        )}


                                                    </tr>
                                                ))}
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            {/* Pagination */}
                            <div className='container-fluid'>
                                {/* Pagination */}
                                <div style={{ display: 'flex', justifyContent: 'center' }}>
                                    <ReactPaginate
                                        previousLabel={
                                            <IconContext.Provider value={{ color: "#000", size: "23px" }}>
                                                <AiFillCaretLeft />
                                            </IconContext.Provider>
                                        }
                                        nextLabel={
                                            <IconContext.Provider value={{ color: "#000", size: "23px" }}>
                                                <AiFillCaretRight />
                                            </IconContext.Provider>
                                        } breakLabel={'...'}
                                        breakClassName={'page-item'}
                                        breakLinkClassName={'page-link'}
                                        pageCount={pageCount}
                                        marginPagesDisplayed={2}
                                        pageRangeDisplayed={5}
                                        onPageChange={handlePageClick}
                                        containerClassName={'pagination'}
                                        activeClassName={'active'}
                                        previousClassName={'page-item'}
                                        nextClassName={'page-item'}
                                        pageClassName={'page-item'}
                                        previousLinkClassName={'page-link'}
                                        nextLinkClassName={'page-link'}
                                        pageLinkClassName={'page-link'}
                                    />
                                </div>

                            </div>
                        </div>
                        {/* /.container-fluid */}
                    </div>
                </div>
            </div>
        </>
    );
}

export default ListAppointment