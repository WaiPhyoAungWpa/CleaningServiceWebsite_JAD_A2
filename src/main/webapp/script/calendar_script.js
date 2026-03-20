const daysTag = document.querySelector(".days"),
currentDate = document.querySelector(".current-date"),
prevNextIcon = document.querySelectorAll(".icons span");

// getting new date, current year and month
let date = new Date(),
currYear = date.getFullYear(),
currMonth = date.getMonth();

// storing full name of all months in array
const months = ["January", "February", "March", "April", "May", "June", "July",
              "August", "September", "October", "November", "December"];

const displaySelectedDate = document.querySelector(".display-selected-date"); // Updated class name

const selectDate = (event) => {
    const selectedDay = document.querySelector(".days .selected-date");
    if (selectedDay) {
        selectedDay.classList.remove("selected-date");
    }

    event.target.classList.add("selected-date");

    const dayNumber = event.target.textContent;
    const dayName = new Date(currYear, currMonth, dayNumber).toLocaleString('en-us', { weekday: 'long' });
    displaySelectedDate.innerText = `${dayName}, ${dayNumber} ${months[currMonth]} ${currYear}`;

    // Set the hidden input value to the selected date in the format YYYY-MM-DD
    const selectedDateInput = document.getElementById('selectedDate');
    const formattedDate = `${currYear}-${currMonth + 1}-${dayNumber}`; // Format as YYYY-MM-DD
    selectedDateInput.value = formattedDate;
};


const renderCalendar = () => {
    let firstDayofMonth = new Date(currYear, currMonth, 1).getDay(), // getting first day of month
    lastDateofMonth = new Date(currYear, currMonth + 1, 0).getDate(), // getting last date of month
    lastDayofMonth = new Date(currYear, currMonth, lastDateofMonth).getDay(), // getting last day of month
    lastDateofLastMonth = new Date(currYear, currMonth, 0).getDate(); // getting last date of previous month
    let liTag = "";

    for (let i = firstDayofMonth; i > 0; i--) { // creating li of previous month last days
        liTag += `<li class="inactive">${lastDateofLastMonth - i + 1}</li>`;
    }

    for (let i = 1; i <= lastDateofMonth; i++) { // creating li of all days of current month
        // Check if the date is today or in the past
        let isInactive = new Date(currYear, currMonth, i) < new Date(new Date().setHours(0, 0, 0, 0)) ? "inactive" : "";
        // Check if the date is in the future and mark it active
        let isAvailable = new Date(currYear, currMonth, i) > new Date(new Date().setHours(0, 0, 0, 0)) ? "available" : "";
        liTag += `<li class="${isInactive || isAvailable || "today"}">${i}</li>`;
    }

    for (let i = lastDayofMonth; i < 6; i++) { // creating li of next month first days
        liTag += `<li class="inactive">${i - lastDayofMonth + 1}</li>`;
    }

    currentDate.innerText = `${months[currMonth]} ${currYear}`; // passing current mon and yr as currentDate text
    daysTag.innerHTML = liTag;

    // Add click event listener to each day (li element)
    const days = daysTag.querySelectorAll("li");
    days.forEach(day => {
        day.addEventListener("click", selectDate);
    });
};

renderCalendar();

prevNextIcon.forEach(icon => { // getting prev and next icons
    icon.addEventListener("click", () => { // adding click event on both icons
        // if clicked icon is previous icon then decrement current month by 1 else increment it by 1
        currMonth = icon.id === "prev" ? currMonth - 1 : currMonth + 1;

        if(currMonth < 0 || currMonth > 11) { // if current month is less than 0 or greater than 11
            // creating a new date of current year & month and pass it as date value
            date = new Date(currYear, currMonth, new Date().getDate());
            currYear = date.getFullYear(); // updating current year with new date year
            currMonth = date.getMonth(); // updating current month with new date month
        } else {
            date = new Date(); // pass the current date as date value
        }
        renderCalendar(); // calling renderCalendar function
    });
});
