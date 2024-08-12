import { React, useState, useEffect, useRef } from "react";
import Header from "./Header";
import SideBar from "./Sidebar";
import { CSVLink } from "react-csv";
import { Chart, PieController, ArcElement, registerables } from "chart.js";
import orderService from "../services/order.service";
import appointmentService from '../services/appointment.service'


const Home = () => {

    Chart.register(PieController, ArcElement);
    Chart.register(...registerables);
    const pieChartRef = useRef(null);
    const areaChartRef = useRef(null);

    const [orderCount, setOrderCount] = useState(0);
    const [appointmentCount, setAppointmentCount] = useState(0);
    const [sumForCurrentMonth, setSumForCurrentMonth] = useState(0);
    const [sumForPreviousMonth, setSumForPreviousMonth] = useState(0);
    const [sumForCurrentYear, setSumForCurrentYear] = useState(0);
    //area chart
    const [monthlyData, setMonthlyData] = useState([]);

    useEffect(() => {
        countOrders();
        countAppointments();
        fetchMonthlyData();
    }, []);

    useEffect(() => {
        if (sumForCurrentMonth !== 0 && sumForPreviousMonth !== 0) {
          createPieChart();
        }
      }, [sumForCurrentMonth, sumForPreviousMonth]);

    useEffect(() => {
        if (monthlyData.length > 0) {
            createAreaChart();
        }
    }, [monthlyData]);

    //Income by month
    const fetchOrdersAndCalculateSum = async () => {
        try {
            const response = await orderService.getAllOrder();
            const orders = response.data;

            const sumForCurrentMonth = calculateSumByMonth(orders);
            setSumForCurrentMonth(sumForCurrentMonth);
            console.log("Sum for current month:", sumForCurrentMonth);
        } catch (error) {
            console.error("Error fetching orders:", error);
        }
    };

    fetchOrdersAndCalculateSum();

    const calculateSumByMonth = (orders) => {
        // Get the current month
        const currentDate = new Date();
        const currentMonth = currentDate.getMonth();

        // Initialize the sum for the current month
        let sumForCurrentMonth = 0;

        // Iterate over each order
        orders.forEach((order) => {
            // Extract the month from the order date
            const orderDate = new Date(order.orderDate);
            const orderMonth = orderDate.getMonth() + 1; // Add 1 to match the format of order month

            // Check if the order belongs to the current month
            if (orderMonth === currentMonth + 1) { // Add 1 to match the format of current month
                sumForCurrentMonth += order.totalAmount; // Use the correct property name
            }
        });

        return sumForCurrentMonth;
    };

    //Income by year
    const fetchOrdersAndCalculateSum1 = async () => {
        try {
            const response = await orderService.getAllOrder();
            const orders = response.data;

            const sumForCurrentYear = calculateSumByYear(orders);
            setSumForCurrentYear(sumForCurrentYear);
            console.log("Sum for current year:", sumForCurrentYear);
        } catch (error) {
            console.error("Error fetching orders:", error);
        }
    };

    fetchOrdersAndCalculateSum1();

    const calculateSumByYear = (orders) => {
        // Get the current year
        const currentDate = new Date();
        const currentYear = currentDate.getFullYear();

        // Initialize the sum for the current year
        let sumForCurrentYear = 0;

        // Iterate over each order
        orders.forEach((order) => {
            // Extract the year from the order date
            const orderYear = new Date(order.orderDate).getFullYear();

            // Check if the order belongs to the current year
            if (orderYear === currentYear) {
                sumForCurrentYear += order.totalAmount;
            }
        });

        return sumForCurrentYear;
    };

    const calculateSumByPreviousMonth = (orders) => {
        // Get the current date
        const currentDate = new Date();

        // Calculate the previous month
        let previousMonth = currentDate.getMonth() - 1;

        // Adjust the month if the previous month was in the previous year
        if (previousMonth < 0) {
            previousMonth = 11;
        }

        // Initialize the sum for the previous month
        let sumForPreviousMonth = 0;

        // Iterate over each order
        orders.forEach((order) => {
            // Extract the month from the order date
            const orderMonth = new Date(order.orderDate).getMonth();

            // Check if the order belongs to the previous month
            if (orderMonth === previousMonth) {
                sumForPreviousMonth += order.totalAmount;
            }
        });

        return sumForPreviousMonth;
    };

    const fetchOrdersAndCalculateSum3 = async () => {
        try {
            const response = await orderService.getAllOrder();
            const orders = response.data;

            const sumForPreviousMonth = calculateSumByPreviousMonth(orders);
            setSumForPreviousMonth(sumForPreviousMonth);
            console.log("Sum for previous month:", sumForPreviousMonth);
        } catch (error) {
            console.error("Error fetching orders:", error);
        }
    };

    fetchOrdersAndCalculateSum3();

    const createPieChart = () => {
        const pieChartCanvas = pieChartRef.current.getContext("2d");

        if (pieChartRef.current.chart) {
            pieChartRef.current.chart.destroy();
        }

        const data = {
            labels: ["Previous Month", "Current Month"],
            datasets: [
                {
                    data: [sumForPreviousMonth, sumForCurrentMonth],
                    backgroundColor: ["#088F8F", "#7CFC00"],
                    hoverBackgroundColor: ["#0047AB", "#008000"],
                },
            ],
        };

        const options = {
            plugins: {
                legend: {
                    display: true,
                },
                tooltip: {
                    enabled: true,
                    callbacks: {
                        label: (context) => {
                            const label = context.label;
                            const value = context.formattedValue;
                            return `${label}: $${value}`;
                        },
                    },
                },
            },
        };

        pieChartRef.current.chart = new Chart(pieChartCanvas, {
            type: "pie",
            data: data,
            options: options,
        });
    };


    //area chart
    const fetchMonthlyData = async () => {
        try {
            const response = await orderService.getAllOrder();
            const orders = response.data;
            const currentYear = new Date().getFullYear();

            // Initialize an array to store monthly data
            const monthlyData = Array(12).fill(0);

            // Iterate over each order
            orders.forEach((order) => {
                const orderDate = new Date(order.orderDate);
                const orderYear = orderDate.getFullYear();
                const orderMonth = orderDate.getMonth();

                // Check if the order belongs to the current year
                if (orderYear === currentYear) {
                    // Add the order's total price to the corresponding month's data
                    monthlyData[orderMonth] += order.totalAmount;
                }
            });

            setMonthlyData(monthlyData);
        } catch (error) {
            console.error("Error fetching orders:", error);
        }
    };

    const createAreaChart = () => {
        const areaChartCanvas = areaChartRef.current.getContext("2d");

        if (areaChartRef.current.chart) {
            areaChartRef.current.chart.destroy();
        }

        const data = {
            labels: [
                "January",
                "February",
                "March",
                "April",
                "May",
                "June",
                "July",
                "August",
                "September",
                "October",
                "November",
                "December",
            ],
            datasets: [
                {
                    label: "Income",
                    data: monthlyData,
                    backgroundColor: "rgba(54, 162, 235, 0.2)",
                    borderColor: "rgba(54, 162, 235, 1)",
                    borderWidth: 2,
                    pointBackgroundColor: "rgba(54, 162, 235, 1)",
                    pointBorderColor: "#fff",
                    pointRadius: 4,
                    pointHoverRadius: 6,
                },
            ],
        };

        const options = {
            scales: {
                x: {
                    grid: {
                        display: false,
                    },
                },
                y: {
                    beginAtZero: true,
                    grid: {
                        borderDash: [2],
                        borderDashOffset: [2],
                        drawBorder: false,
                        color: "rgba(0, 0, 0, 0.05)",
                        zeroLineColor: "rgba(0, 0, 0, 0.1)",
                    },
                    ticks: {
                        callback: (value) => {
                            if (value >= 1000) {
                                return `$${value / 1000}k`;
                            }
                            return `$${value}`;
                        },
                    },
                },
            },
            plugins: {
                tooltip: {
                    enabled: true,
                    callbacks: {
                        label: (context) => {
                            const label = context.dataset.label;
                            const value = context.formattedValue;
                            return `${label}: $${value}`;
                        },
                    },
                },
            },
        };

        areaChartRef.current.chart = new Chart(areaChartCanvas, {
            type: "line",
            data: data,
            options: options,
        });
    };


    // Create an instance of the OrderService class
    // Function to count the orders
    async function countOrders() {
        try {
            const response = await orderService.getAllOrder();
            const orders = response.data;
            const orderCount = orders.length;


            setOrderCount(orderCount);
        } catch (error) {
            console.error("Error counting orders:", error);
        }
    }
    async function countAppointments() {
        try {
            const response = await appointmentService.getAllAppointment();
            const appointments = response.data;
            const appointmentCount = appointments.length;


            setAppointmentCount(appointmentCount);
        } catch (error) {
            console.error("Error counting orders:", error);
        }
    }



    return (
        <>
            {/* Page Wrapper */}

            <div id="wrapper">
            <SideBar isAdmin={sessionStorage.getItem('isAdmin') === 'true'} isStaff={sessionStorage.getItem('isStaff') === 'true'} />
                {/* Content Wrapper */}

                <div id="content-wrapper" class="d-flex flex-column" style={{ backgroundImage: `url(/banner_3.jpg)`, backgroundSize: 'cover', height: '100vh' }}>
                    {/* Main Content */}

                    <div id="content">
                        <Header />
                        {/* Begin Page Content */}
                        <div className="container-fluid">
                           

                            <div>
                                {/* Content Row */}
                                <div className="row">
                                    {/* Earnings (Monthly) Card Example */}
                                    <div className="col-xl-3 col-md-6 mb-4">
                                        <div className="card border-left-primary shadow h-100 py-2">
                                            <div className="card-body">
                                                <div className="row no-gutters align-items-center">
                                                    <div className="col mr-2">
                                                        <div className="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                                            Earnings (Monthly)</div>
                                                            <div className="h5 mb-0 font-weight-bold text-gray-800">${sumForCurrentMonth.toFixed(2)}</div>
                                                    </div>
                                                    <div className="col-auto">
                                                        <i className="fas fa-calendar fa-2x text-gray-300" />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    {/* Earnings (Monthly) Card Example */}
                                    <div className="col-xl-3 col-md-6 mb-4">
                                        <div className="card border-left-success shadow h-100 py-2">
                                            <div className="card-body">
                                                <div className="row no-gutters align-items-center">
                                                    <div className="col mr-2">
                                                        <div className="text-xs font-weight-bold text-success text-uppercase mb-1">
                                                            Earnings (Annual)</div>
                                                            <div className="h5 mb-0 font-weight-bold text-gray-800">${sumForCurrentYear.toFixed(2)}</div>
                                                    </div>
                                                    <div className="col-auto">
                                                        <i className="fas fa-dollar-sign fa-2x text-gray-300" />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    {/* Earnings (Monthly) Card Example */}
                                    <div className="col-xl-3 col-md-6 mb-4">
                                        <div className="card border-left-info shadow h-100 py-2">
                                            <div className="card-body">
                                                <div className="row no-gutters align-items-center">
                                                    <div className="col mr-2">
                                                        <div className="text-xs font-weight-bold text-info text-uppercase mb-1">Orders
                                                        </div>
                                                        <div className="row no-gutters align-items-center">
                                                            <div className="col-auto">
                                                                <div className="h5 mb-0 font-weight-bold text-gray-800">
                                                                    <span className="orderCount">{orderCount}</span>
                                                                </div>
                                                            </div>

                                                        </div>
                                                    </div>
                                                    <div className="col-auto">
                                                        <i className="fas fa-clipboard-list fa-2x text-gray-300" />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    {/* Pending Requests Card Example */}
                                    <div className="col-xl-3 col-md-6 mb-4">
                                        <div className="card border-left-warning shadow h-100 py-2">
                                            <div className="card-body">
                                                <div className="row no-gutters align-items-center">
                                                    <div className="col mr-2">
                                                        <div className="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                                            APPOINMENTS</div>
                                                        <div className="h5 mb-0 font-weight-bold text-gray-800">{appointmentCount}</div>
                                                    </div>
                                                    <div className="col-auto">
                                                        <i className="fas fa-comments fa-2x text-gray-300" />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                {/* Content Row */}
                                <div className="row">
                                    {/* Area Chart */}
                                    <div className="col-xl-8 col-lg-7">
                                        <div className="card shadow mb-4">
                                            {/* Card Header - Dropdown */}
                                            <div className="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                                <h6 className="m-0 font-weight-bold text-primary">Earnings Overview</h6>
                                                <div className="dropdown no-arrow">
                                                    <a className="dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                        <i className="fas fa-ellipsis-v fa-sm fa-fw text-gray-400" />
                                                    </a>
                                                    <div className="dropdown-menu dropdown-menu-right shadow animated--fade-in" aria-labelledby="dropdownMenuLink">
                                                        <div className="dropdown-header">Dropdown Header:</div>
                                                        <a className="dropdown-item" href="#">Action</a>
                                                        <a className="dropdown-item" href="#">Another action</a>
                                                        <div className="dropdown-divider" />
                                                        <a className="dropdown-item" href="#">Something else here</a>
                                                    </div>
                                                </div>
                                            </div>
                                            {/* Card Body */}
                                            <div className="card-body">
                                                <div className="chart-area">
                                                    <canvas ref={areaChartRef} id="myAreaChart" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    {/* Pie Chart */}
                                    <div class="col-xl-4 col-lg-5 d-flex align-items-center ">
                                        <div class="card shadow mb-4">
                                            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                                <h6 class="m-0 font-weight-bold text-success">Income Comparison</h6>
                                            </div>
                                            <div class="card-body">
                                                <div className="chart-pie pt-4 pb-2">
                                                    <canvas ref={pieChartRef} id="myPieChart3"></canvas>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                {/* Content Row */}

                                {/* /.container-fluid */}
                            </div>

                        </div>
                    </div>
                </div>


            </div>
        </>
    );
};


export default Home