import React, { useEffect, useState } from 'react';
import Header from '../Header';
import SideBar from '../Sidebar';
import { Link } from 'react-router-dom';
import ReactPaginate from 'react-paginate';
import productService from '../../services/product.service'
import {AiFillCaretLeft, AiFillCaretRight } from "react-icons/ai"; // icons form react-icons
import { IconContext } from "react-icons"; // for customizing icons
import "../../../src/my-styles.css"

const ListProduct = () => {

    const [productList, setProductList] = useState([]);
    const [msg, setMsg] = useState('');
    const [searchTerm, setSearchTerm] = useState('');
    const [currentPage, setCurrentPage] = useState(0);
    const [productsPerPage] = useState(5);

    useEffect(() => {
        productService
            .getAllProduct()
            .then((res) => {
                console.log(res.data);
                setProductList(res.data);

            })
            .catch((error) => {
                console.log(error);
            });
    }, []);

    const handleSearch = (event) => {
        setSearchTerm(event.target.value);
    };

    const filteredProducts = productList
        .filter((product) => {
            return (
                product.productId.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                product.productName.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                product.image.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                product.brand.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                product.price.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                product.description.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                product.quantity.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                product.createdDate.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                product.updatedDate.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                product.deliveryId.toString().toLowerCase().includes(searchTerm.toLowerCase())

            );
        });

    const pageCount = Math.ceil(filteredProducts.length / productsPerPage);

    const handlePageClick = (data) => {
        setCurrentPage(data.selected);
    };

    const offset = currentPage * productsPerPage;
    const currentProducts = filteredProducts.slice(offset, offset + productsPerPage);

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
                            <h1 className="h3 mb-2" style={{ fontWeight: "revert", color: "#000", fontSize: "20px" }}>Products</h1>

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
                                                    <th>Image</th>
                                                    <th>Name</th>
                                                    <th>Brand</th>
                                                    <th>Price</th>
                                                    <th>Description</th>
                                                    <th>Quantity</th>
                                                    <th>Created Date</th>
                                                    <th>Updated Date</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {currentProducts.map((cus) => (
                                                    <tr key={cus.productId}>
                                                        <td>
                                                            <img src={cus.image} alt={cus.productName} width="100" height="100" />
                                                        </td>
                                                        <td>{cus.productName}</td>
                                                        <td>{cus.brand}</td>
                                                        <td>{cus.price}</td>
                                                        <td>{cus.description}</td>
                                                        <td>{cus.quantity}</td>
                                                        <td>{cus.createdDate}</td>
                                                        <td>{cus.updatedDate}</td>
                                                        <td>
                                                            <div className="btn-group" role="group">
                                                                <Link to={`/edit_product/${cus.productId}`}>
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

export default ListProduct