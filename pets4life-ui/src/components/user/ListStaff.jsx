import React, { useEffect, useState } from 'react';
import Header from '../Header';
import SideBar from '../Sidebar';
import { Link } from 'react-router-dom';
import ReactPaginate from 'react-paginate';
import customerService from '../../services/customer.service'
import {AiFillCaretLeft, AiFillCaretRight } from "react-icons/ai"; // icons form react-icons
import { IconContext } from "react-icons"; // for customizing icons
import "../../../src/my-styles.css"

const ListStaff = () => {

    const [customerList, setCustomerList] = useState([]);
    const [msg, setMsg] = useState('');
    const [searchTerm, setSearchTerm] = useState('');
    const [currentPage, setCurrentPage] = useState(0);
    const [customersPerPage] = useState(5);

    useEffect(() => {
        customerService
            .getAllCustomer()
            .then((res) => {
                console.log(res.data);
                setCustomerList(res.data);

            })
            .catch((error) => {
                console.log(error);
            });
    }, []);

    const handleSearch = (event) => {
        setSearchTerm(event.target.value);
    };

    const filteredCustomers = customerList
        .filter((customer) => customer.isStaff === true)
        .filter((customer) => {
            return (
                customer.userId.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                customer.fullName.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                customer.phone.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                customer.dateOfBirth.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                customer.gender.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                customer.email.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                customer.address.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                customer.createdDate.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                customer.updatedDate.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                customer.status.toString().toLowerCase().includes(searchTerm.toLowerCase())
            );
        });

    const pageCount = Math.ceil(filteredCustomers.length / customersPerPage);

    const handlePageClick = (data) => {
        setCurrentPage(data.selected);
    };

    const offset = currentPage * customersPerPage;
    const currentCustomers = filteredCustomers.slice(offset, offset + customersPerPage);

    return (
        <>
            {/* Page Wrapper */}
            <div id="wrapper">
            <SideBar isAdmin={sessionStorage.getItem('isAdmin') === 'true'} isStaff={sessionStorage.getItem('isStaff') === 'true'} />
                {/* Content Wrapper */}
                <div id="content-wrapper" className="d-flex flex-column" style={{ backgroundImage: `url(/banner.jpg)`, backgroundSize: 'cover', height: '100vh' }}>
                    {/* Main Content */}
                    <div id="content">
                        <Header />
                        <div className="container-fluid">
                            {/* Page Heading */}
                            <h1 className="h3 mb-2" style={{ fontWeight: "revert", color: "#000", fontSize: "20px" }}>Staffs</h1>

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
                            <div className="card shadow mb-4">
                                <div className="card-body">
                                    <div className="table-responsive">
                                        <table className="table table-hover" id="" width="100%" cellSpacing="0">
                                            <thead style={{ color: "#000" }}>
                                                <tr>
                                                    <th>Staff Id</th>
                                                    <th>Full Name</th>
                                                    <th>Phone</th>
                                                    <th>DOB</th>
                                                    <th>Gender</th>
                                                    <th>Email</th>
                                                    <th>Address</th>
                                                    <th>Created Date</th>
                                                    <th>Updated Date</th>
                                                    {/* <th>Status</th> */}

                                                </tr>
                                            </thead>
                                            <tbody>
                                                {currentCustomers.map((cus) => (
                                                    <tr key={cus.userId}>
                                                        <td>{cus.userId}</td>
                                                        <td>{cus.fullName}</td>
                                                        <td>{cus.phone}</td>
                                                        <td>{cus.dateOfBirth}</td>
                                                        <td>{cus.gender === true ? "Male" : "Female"}</td>
                                                        <td>{cus.email}</td>
                                                        <td>{cus.address}</td>
                                                        <td>{cus.createdDate}</td>
                                                        <td>{cus.updatedDate === null ? "None" : cus.updatedDate}</td>
                                                        {/* <td>{cus.status === true ? "Active" : "Inactive"}</td> */}
                                                        <td>
                                                            <div className="btn-group" role="group">
                                                                <Link to={`/edit_staff/${cus.userId}`}>
                                                                    <i class="far fa-edit text-warning"></i>
                                                                </Link>
                                                            </div>
                                                        </td>
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

export default ListStaff