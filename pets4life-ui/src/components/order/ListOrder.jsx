import React, { useEffect, useState } from 'react';
import Header from '../Header';
import SideBar from '../Sidebar';
import { Link } from 'react-router-dom';
import ReactPaginate from 'react-paginate';
import OrderService from '../../services/order.service';
import { AiFillCaretLeft, AiFillCaretRight } from "react-icons/ai"; // icons form react-icons
import { IconContext } from "react-icons"; // for customizing icons
import "../../../src/my-styles.css"

const ListOrder = () => {

    const [OrderList, setOrderList] = useState([]);
    const [msg, setMsg] = useState('');
    const [searchTerm, setSearchTerm] = useState('');
    const [currentPage, setCurrentPage] = useState(0);
    const [OrdersPerPage] = useState(5);



    useEffect(() => {
        OrderService
            .getAllOrder()
            .then((res) => {
                console.log(res.data);
                setOrderList(res.data);

            })
            .catch((error) => {
                console.log(error);
            });
    }, []);

    const handleSearch = (event) => {
        setSearchTerm(event.target.value);
    };

    const filteredOrders = OrderList
        .filter((Order) => {
            return (
                Order.orderId.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                Order.userId.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                Order.orderDate.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                Order.totalAmount.toString().toLowerCase().includes(searchTerm.toLowerCase())
            );
        });

    const pageCount = Math.ceil(filteredOrders.length / OrdersPerPage);

    const handlePageClick = (data) => {
        setCurrentPage(data.selected);
    };

    const offset = currentPage * OrdersPerPage;
    const sortedOrders = [...filteredOrders].sort((a, b) => b.orderId - a.orderId);

    const currentOrders = sortedOrders.slice(offset, offset + OrdersPerPage);



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
                            <h1 className="h3 mb-2" style={{ fontWeight: "revert", color: "#000", fontSize: "20px" }}>Orders</h1>

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
                                                    <th>ID</th>
                                                    <th>User</th>
                                                    <th>Order Date</th>
                                                    <th>Total</th>
                                                    <th>Paid</th>
                                                    <th>Transaction Cap</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {currentOrders.map((cus) => (
                                                    <tr key={cus.orderId}>
                                                        <td>{cus.orderId}</td>
                                                        <td>{cus.userId}</td>
                                                        <td>{cus.orderDate}</td>
                                                        <td>{cus.totalAmount}</td>
                                                        <td>{cus.isPaid ? "Yes" : "Not yet"}</td> {/* Simplified the conditional */}

                                                        {/* Check if imagePayment is null or not */}
                                                        {cus.imagePayment === null ? (
                                                            <td>
                                                                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSX0KT-5SahDG6Zfe3yvwWvxFfCuADRwr-WdImUwQBGLBa4ZaTlCtruQ7_zjot-_hArH5w&usqp=CAU" width="100" height="100" alt="No Image" />
                                                            </td>
                                                        ) : (
                                                            <td>
                                                                <img src={cus.imagePayment} width="100" height="100" alt="Payment" />
                                                            </td>
                                                        )}

                                                        <td>
                                                            <div className="btn-group" role="group">
                                                                <Link to={`/detail_order/${cus.orderId}`}>
                                                                    <i className="fas fa-outdent text-warning"></i> {/* Fixed class attribute */}
                                                                </Link>
                                                            </div>
                                                        </td>

                                                        {/* Check if isPaid is false to show the edit link */}
                                                        <td>
                                                            <div className="btn-group" role="group">
                                                                <Link to={`/edit_order/${cus.orderId}`}>
                                                                    <i className="far fa-edit text-warning"></i> {/* Fixed class attribute */}
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

export default ListOrder