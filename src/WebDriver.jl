module WebDriver

using PyCall

struct Driver
    o::PyObject
end
PyObject(x::Driver) = x.o

struct WebElement
    o::PyObject
end
PyObject(x::WebElement) = x.o

function init_chrome(;headless = true)
    wd = pyimport("selenium.webdriver")
    options = wd.ChromeOptions()
    options.headless = headless
    Driver(wd.Chrome(options=options))
end

function with_chrome(fn; headless = true)
    d = init_chrome(headless = headless)
    try
        fn(d)
    finally
        quit(d)
    end
end

struct ActionChain
    o::PyObject
end

function ActionChain(x::Driver)
    wd = pyimport("selenium.webdriver")
    ActionChain(wd.ActionChains(x.o))
end

PyObject(x::ActionChain) = x.o

get(driver::Driver, url) = driver.o.get(url)
quit(driver::Driver) = driver.o.quit()
refresh(driver::Driver) = driver.o.refresh()
findone(driver::Driver, xpath) = WebElement(driver.o.find_element_by_xpath(xpath))
findall(driver::Driver, xpath) = map(WebElement, driver.o.find_elements_by_xpath(xpath))
findone(element::WebElement, xpath) = WebElement(element.o.find_element_by_xpath(xpath))
findall(element::WebElement, xpath) = map(WebElement, element.o.find_elements_by_xpath(xpath))
attribute(element::WebElement, name) = element.o.get_attribute(name)
text(element::WebElement) = element.o.text
Base.getindex(element::WebElement, name) = attribute(element, name)

end # module
